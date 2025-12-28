# **[Link Aggregation and LACP with Open vSwitch](https://blog.scottlowe.org/2012/10/19/link-aggregation-and-lacp-with-open-vswitch/)**

Published on 19 Oct 2012 ·  Filed in Tutorial ·  956 words (estimated 5 minutes to read)

In this post, I’m going to show you how to use link aggregation (via the Link Aggregation Control Protocol, or LACP) with Open vSwitch (OVS). First, though, let’s cover some basics.

In the virtualization space, it’s extremely common to want to use multiple physical network connections in your hypervisor hosts to support guest (virtual machine) traffic. The problem is that modern-day networking is—for now—largely constrained by the presence of Spanning Tree Protocol (STP), which limits the use of multiple connections between network devices (especially switches). Since most hypervisors have some form of virtual switch to support guest traffic, and since users don’t want to be constrained by STP the hypervisors have had to find workarounds.

The Spanning Tree Protocol (STP) prevents network loops in Layer 2 Ethernet networks by creating a logical loop-free tree-like topology, allowing for redundant links but blocking redundant paths to avoid broadcast storms and MAC table corruption. It works by electing a Root Bridge, determining the Root Port on each non-root switch with the lowest cost path to the Root Bridge, and blocking redundant paths to maintain a single active loop-free path throughout the network.  

![looped](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAcUAAADhCAMAAACOVV4iAAABQVBMVEX///8QbZkAAAC2+pkAapcAaJb7+/sAZpXv7+/Z2dnT09P/wgAAZJQAXpDq6uoAYZKvx9bJ3OZmkrFdj7DS4elmmrfCwcCxsbFNTU3C1eDr7/JFhqtZWVk0eqHf5u2kpKR0nLo0NDQcHBwjIyPKysqkwNOErMTg4+WTssh+pL9vb2+ZmZm30eA9PT14eHhnZ2eKiooAV4wQEBD/yQCp6o2X030ATIZ6rmOIwHFsm1dEaTOFgIeVkZZVf0I7Nj0pThURKQBtZm9RTFRkjlE7VTFQVk4+TTgrOyV5c3s5WikXDhoeLxYpRxomLCNfZVxCXzUxRyhQXU0KHgAhOhYoIiozOjEWNgBRckNzVQCyhgDQmwCbcgBcTC5gRQBLOADdqgA6MBo8RFE2JABXNgBTSTlbRxkWHxMhFwtQWGYTUnJJPU1aZeW5AAAgAElEQVR4nO2dCZujyJWugYIAqZBAAoEAgZQpIaF96ayu6iXt6XWqx0u377TdS43dvp7xjO/8/x9wT7AGEqQ2yJLS+T3dJaUWdCLeiHNOLABFPetZz3rWs571rGc961nPetaznvWsZ6VVqYJG8AQt25XMT4wW+s5rWmeFH1A10EB48DcGnQU639KDNcg3R5vslnHV8ctXD8tSfdjU8NMXpiUD2iwRJWyYauYnVgyzU7Au08EPFSaU9uBv6Ez7MSkyOQXx35rsvNZhpvihG5Xl4RY5YVbn2leCJkxHX90yC0q4zSm8MN1lFFKsr1aLW2a5WmT34kiXQ7E6re+81mG6+GGwWEGLXi1W10kRrNKYPkJ5FLMUUgQJN/u/djkUsxRSpHA1MHs/fcEUR+A0MUW9sxhR084CXl+1B8J02YFe1sUxUNCXnUmV0lbLzmq0RXHgP8IHVrj2Bu3FaNWZ4hY9WHUmOgopCl34gN9nq4tOV2+vRp0OfLPaWRZNOKJYB/uDvqdNlrqOi7Fsw09Wpp3OCgndRWeJrdulOJoul/4Xp+3uYLnErmi0Wi679ai+KqvOsotLiHR4e9rWtU4H/uy2uzvGPI58q1YABSi2ISrM0YC5HVGjW6Y+Z+YdRoc3J1T9hmFuGR0xt50bpi/sUkRtP6bofr++Zfz408XfYZYBRXTjf2Dg1xV+o4OW4MepKf6nWIUU6xv/h0ZhyOtjS3AE14Pop0HpNtjMHYpV/wM3dVw5N0HUD18Sgvoa+H+14a9FUJap4JdsEzTo96AJ5DZgyQjHxRXulFWqDcXSmQV2s0DJp9jBvQnVEW6NbWC1Q3GKC6XjWtBwgQbMZjRiNho1mvv11kYrBvrclOlTqA/ZBBDsQNVAtWyYh2PqCQopdnD7XMDvQIvUKGGOKW4Yrc7gbKaOBChcBdrqLsU5/qLfxBa4VPgQ2GZ4aYXrawoNsourAePcVPFBplBJCyjPowYOUhOm38Z+NMxuMAKodChaFfpffzLAHXWCovx1sJzfbMDoHYp+VcDzClTFHMpyywx0Zk4FbVdnOgLu1dRosxlVNps67p4dBNWljfBjwQooItw0cbfBdU3hdhZQ1HyzwNhu5wZ6WmWHouB/UWNuMcUVPsTNyO/SGnPjU6z7SbsOf039aoCXIFufC1PmfTlUv5b9ekwoAr7RBlCMVn0m8KgCs/F7jM709Uo7iyLuv/iLmCJukZttim08GsEUq8wGhRS7zKrLFD/82qaopSjqIcUls9S0fibFjY+sH1IE7COm778095GNQopzqJolFVCEChi0N7sJ8CMpzrkSijhMQslw9F5Bg8Me1XdHCGGA8DyDot8qQ4+6wSj7QgU/ESKPuggiZZ8S+rjWlpiicNtvbx5O7E8RUEQIUb6xOOJXMFawM6BY8aO34Pe46iaDIuUbOAk8agf/s4TvdVMeVQuGmTpzW6cq2DnhZpkxFn0sJRQ3MUVwGWCdziwnmzC7wfH8htGnDNPZ9qh9nyJUEtMPs5sNfjb1Q/88zm4EP8HAxV/hJze+J4WnJeTtweB9BLggz8KucBL8YkARGhyz6TNg8G3nNsuj4ofbjZ/KLKAsG9wG9PilwLcw/Q0OmTinw0eGwuLs7agBTqFazafBE9Seg9ecz7EpS9ysKpP2fAK1Pp37uXW7vaygabtTWcwh+ZlHmaXQmQcZ4aozX+Bn4FG1Thun8JCGz/1cXptPsH9uz/3ZAdSFt3Wc7OBeUnhuQ1E3bVAHetqi3cbDIkpYtTuanwy35zhJnszbK1SZgDmd+YhazCOnPpi3g0f4oj/SAI/anXeq5Et+fWmTdjCWqq/my8HEbwbYbb03IZR6FvwzD1Lm8L3gIfw3fLb1NSp6jwrjYuql+EDJz/oRB8fZ4kpC/ChCibWRcGqdNgRtFyV5ihIrt17aPbLQ95vikpkWWoozVdEgwT7965o/kHroA9PBAJxtndL0fgm5TYa63YG29P3hkVrsc/grfaDPIboI+oopIcKfIYgb8zOSLW1fdfmj7vYAt+FHms3yx+ad0fFfnOybksBzHRsIF1WIj+9rxJ+tkbZnoelh1bXBwyNAVNG0CvZk8HDG7xwhoaoNKqcMS6v7LKwPtIEfeTXtvY0ynvWsx9ToomLOP4+EE8JQvirPFIuRdlxg0c9Ic3dVFEVhz36MWPUB6P2N4ksTc1z41udF/nhRFKu3Bx5oytzc9Dv7P3dt2rMfZVuXSbFy6KBxWviq52UooohG1aBXokrwBGq4UhXCt6JHpF02RVSpRKUIjl2Nn/maBjPb9RFVGfkfQuSHr1chRaEzb99M8RwoPJl38fyrvujc3Gjw1mQ+b0MsQYt+ezm9yLgYUax25nNsPFWFxzneksEMJu2bZC9nSHE16W4W1Ag+3QHowhIKWGjW9ugKKfYxuJsuhfo6NNW+RqFOv45nbEYUrhZtjqjJEgo8v2SKwgYvWd8OqDqeMB7heVAGb5zR491T084AD+Sn8EGEcBPtQpDs4AK+xznvAhRQrOIFV2BF6X7oh3+hL+JnHV3YVCqVUb+K/MXSy8xRQ4rdpf/vJAx/K/jXn9FG7QGFCwEUN50OFGyKS6l1RvAiQ1Vv4HF0ZJZ3YQoodn14g5uw/PAEtf3tqpPpgOmA2pWgpi46u1n587fQ0Dr+0iKG6sNBHU2YTJZT36PixQu/lNNbXLAb8Df4cX7VLjWgGCQtAE/3mzNUREixo1dukL8iNOoL1IX3xaAJAryFjxMHQcY/y2EeDRHDuOh/ED7nF2wwj5e8rlbBNn/ke57OlBr5O3E6EDbamGf1tk75a91QS7fYxbYvlKJfisptxU/LqIHfNv1NDsF6Z/RBkmKl7094QxaAC3jVDpViJuBrqtTgdjFtT/DuIfxkgb3QojNd3EKH1PqT7hJKP7idTJeri/SoVWYJxahQ3f5q2sbcprer1Q1e3mUWy+nyJp6tmfquBnJU/G93s5riPcnaZjFdXvdActrtdqfQhEf6NCjrSO/6e83ag1FXHwWvTP1FLfhbqBS6/lsUxXoXq45N7AalqHS7/vCCqVemetLPBhr5AB/yl9tG4ePTUxgXy1X5g+3rTj3P1jPFpyC0fKb4BCQ8QqQon+I/OcRH0bVPQj8L65niU9AzxaegZ4pPQf/UFFXjKD3CVK9zlEEzFJ4Q8c9MUabFPZKk5HnNNUaHbhE7VcYBFiUm1TzDDPaA7KOIjlK5ZSzYIk+kd8XyhCRvRvNs8AbvzqyKXm6bd6Mfe8AiwxbDD0meyo/0aG/PA3JaSvNhke8rLiWU3bXNPfZkWJRNElmZEFszOZY7g88Ztv+GKBtrq1oqRdSqZVjEKdsWNSwf41puSPQhFBs8z+2KJSTZNSl6eT1UvUHJPkel91kk2lJkEVfrOcOcC5c5NhfXE0dUmpLIcihHHgYQJUOW2HL7omPx+yxSDMqZeYFFNdng2EMoZrscUnyPMsOj4g7OeeedT7RXmS6HJimKLYQ8O/iUODbFYfa162Z0UFGsKNpKj5ViibhNcCz+xxpbNBf8IG+4HF0uRSNsVpzI20qLTlkENvn/2cPEIhdD3E8R9biMGqNteZbIgY85blBlngr/l0oRDfksi2g3MUhW4WNmYJE0dKBpZVL0wtZgK65hphJDLyk0y4VNhuVnMvxyqRTdKNopkLJQJmlRUmg2bsSi3PC72D6KZtzBWV4iuiBRe/zYlMcWy4c9ET5YKkWzGfkGjhcJn0D2SsWZQQ/yP1cbOjZYlEERtaSwZDbk6qbrEYqPlByUZQ0ZR6wSKaKxFHcSGD0QFrmRq6PJgoozI6Czh6LBBuWA+lJcdWzHsuzkaBYvhe215jbgWakUG3ZgOAcWeY0haVFSPDu2SMIQ6SyKahKAoAUObdHP/sLsPfgyS4/tuN1zhuw3i/IoJj0GANEtS+IJkzIs4mdGyPRhim5EvuVAcmAScqyEYvxMchv4jzIpymHIZ1sqtsghTMqySByauD9lUDToVKSI3CZtE6JlypTtGGJQx6VRVA+xyMUWBe9wciP6zEMU0TjOa+xxwxySh4tyuzhq4LaB3SldJkXkSbFFLQPyF1JhQyadq+j5EDMourWwcadjLD8mJ0XgB41xOMRoyJH/LYmiHHW3dB7CKuQsDXzOGIZDDKMR43mAomlJycG4Gi2GCWmQMgVaezMrGt7UPCcwpDSKqJmyCKL8rkW1oaGEhLBFQfvepoiavtGsWLOHNDFUgU8mWWHNlRUYQAUtQ5XXUbWSFLu/+vWv/+WzI0+8R9rbzz/7dGvbbU8KGlXNBp9JWkRkzjVvhi3yS1dTZ8nYIZ9ig85MTunh9vBzFlaZrIbtuiyKDpeZnLIpi1wKe0tfkueEnmKLYjBK5CCwOpTbitWz2PSR4+yUVt0kiCYUhfYXdy9evHj15VHXp6t+df/q7u7Nl+SVM0yFjy0yCIuUtEHANzSCbcySuJFPMRyTsZxop49kEVKREY6HaV5uRIctiaJMhxZJdL5FBlJjizyHjS0iKQbtk22quJiem2ibYgSTdlwiz08o/urNi0A/HLEhsfL1q+BLX7xNLPLDAas0INbL7n6LWNowyDFzDkU0xN2VBfQtoyWSHZzI7Tnc+cOD8a4at41yKHq+e+F5u2kMiZmblEWsPba4ML6IKYsIitGYjLM9dVwj55jzqsxxiYbDxjNw049CiC/u/vXw8t68ir71ccQ+StlgPO8MD7AIorSRasrZFE3F97mW1zApNGvEmqXbRpLaSLKaJBVlUESKFFtEPWBR3EJrLpHzERRRqxY1AF6qJQ00V3waIs23wr6I5i9ivT7Yp2r38Zfugo3haLyOf0uMZzIfsoh3ZHI+jbMyKYblZ8fgc1J5IJ3XNoxGKlctnKIaZqAtyBtd+gCLeNehSYsiishTWsdJcVwyQcBVpo3q9bpQ/TihePeZUD9IwttXybe+qQh1gXKPtailzkiLwFfo2u7KlByHE94aiqkZ08waY9lZg6zN4mfg4kjO8daY3W8RzblOapIjnkdtuPKRcp3tKtOXt33Qv31BUGT6B4pJvvTi/t/6txP1aItks5aySNW7wVw/QRENa8lClljjD9DMIR04yzp6sWsaXk1MLJLEByyJPpTqiXjIHl2wCwKhRKq2rkk1CQ5aqwX/iP6fxCz0h06qbLjKRv7dXbRvyL5YPVCf3xEU9Wp15K5TP0esAgf/hH8Soh2SIm9o3WCRmKRoGo0j5TRSqx5sQ+tOp93CNDrBojTEmjHohlc4S8+k8wqeofQUFob7LZ7mmmOOk4bpUFtzyHafVBmFfpXw+OjguDh9nXzrN/gFN1V5HDQiVsQv4Wlr+JOGULk1wLIdIk6LhEUERcs+UrSbqhoeqkxbdgpTW+sda5E9TFWNKA+6kYtPmcq1zIbhNFVDpNcIHCfryLVWgxqnam1NUOSJI1GUHicqd18fHEHqv40hvnm7Q5FvGaralOE1bmjwNNszaFdt9NJxg6QYlA3tULRZcqHAz+TDaS38J6QTLJ9aXYQwSFZNUNDj9lPskUKuHNJsvBwMCRW2Nb3WiT/Cj8mq4bxKdxBtTU9RrDnDdY1l8QyPhUybtczmWvXMXIqSW+2SEX8ejRe/PWK8+Ek0Prn7jbBNkVOQN3Q9z1zTUgNI8IahzMYypaQwEhRFKFtyncM0xUSs5Zim0VNt+AHTgvEYsjjea6SaBk9SxIctOLVBqTJwLPR+Gg/sWfwPNCse/kpPM3EkRXE4mmr1KE6nKEqqAd4KF0p0Z85QHCOerkm5FKFs0/REXudjyDjvXv/mqLMQ337sh8bXvwtODSQpSoa7hsivIIu1TbPHi1RPknjOHKfKl1AUh/UpcbHKHIqsTY0ty7NRkxU9yuW5oclalOmQx0xRDKrsZGCZSlHkevhKyU1onSxN4ZVTNHaRSQ3TywEERXGcsihFEbfRMceK5rCm9tzGhzNwrTSXRzGrbNri919NVkcWWOt8e3//9Sfht0iK/BA7Hpp2htJYdQ3JpnCzHZtWdl8MypYkknkULepDPMxUXVFSVZWHHs7byjiXIhy2Sx62EKUo8qjHcRatuhzXo1QJIput0KJr5lHklXpXJyxKZzcs7ZkNW3Iba4puoZqJ382juNUcYutOcDyoUq3ER0rFRdZFDYsTZ8Zadpsm56ng+RyUToBiipwCtT0iajvPo9qmAeNt0XNqtqNAw8B9W8yluHPYQpSiKFIWRH7RVTnRMBwbP+F4yTNTjTWhyFkAkbRoe7eHiGdmembL4Wmz5bf5HIr89pGKUhqRaBmUIirUh2aTRUrDhQCijLf2qIQUecvcsig3Ltoq/AwHAMcObzZtCjfWPIqcvX3YQpSmOENDEXojBbVtmeO144l0azshiSlytrNlUdqj2jVpPZMl2jRdaBWmir+VTZGzhBIaKFa6L9Ls2oNsGQ0duqa6uFmxXM1LDRBDipy1XbZcijRbsxwonNODuDuTPUfMp8jttI1ilM5upLGJFL5G9RS0NuQaBeVUVXOY2RcBoq6nL4WdzlFVVVahpkRo/xw/DCo0k2JGlRUlkiKLt53I4F4apgFJCIJcFa/Hq+m5b58i9C9926LcvsjRvI1scTZDithzVDefon/Yk64evkdpipCSeqYlGbJr1Hqm4lcx36RS8T+kiCdati3aGi/iQT80d8WfKnX9orNbo35MsbSyUWmKomyqDjQraFFjnrUQpNA9s+E4GdmN5Gg7FuXGxbFNDxEL1QTDKRr5FZpDkVO1bikFTVOE4eLaHEtDxxlDYDBmPF6rX1NWasbapxhMtGxZtDV3w4v+Igjr12Q4jbi12RUoslJZZaO2+qKt9Jr+SnAP/9kEepzVU6TdUb/USKZsYuXnqBRltqBDUgYPwyvkr5GPzQyKmYctRCmKrDFWXBhOQYuyWU6lejzrNhUD0bt9UZwNdi3K2cv6gNYOK6pawTPDhNLZDRtuu/GLE63nbllkOzVullXbuR61VpP8rSc1XHoxzHDTi+0+RTzvVg7ErZEG+BfIxWlpBr2QH0MiwLmOM7O34yIM37MgnkSRx0cq7ZSFrWHEfrG2s3ar04y5ldzs5gBhiqJcLXrKJtaWR2XZsIn6f9F+i+XSNuO+uD1bFmosHbJIQ2qtZh+pKLnrIw0SbXWYPUF2JsW1V2JBt7KbAwQUa3j+IcMiwTxaVKXUC2KhkyzKKluKIr89u7xHkjce17MPW0wxlWMtEsdur549E1gfaHs00bdeqOgDYVre7ZFIi/ROlkXLLIuyDkVQ7B0t2chu9wUJeUdb5DbSE4zEwZDwsCo3la1X6iOBmpZ427X4h9DgZplhUX2jbb9Szz4bM6GI6pV9y9WDrb9HeFqjRIr7LdpWRdgZER8q4SZzblsLb7xWKSmFI39jS+j2UEdA9MV9dVbptnewDuqjTXnXOROOpggWnXbFY9T9jNnZtu2rzrRR/fM/3d9/c1NSt1zl3Mce3R5695hjrs6we5VkfN68dkk3uTz14gKDP350d3f3+stPMt4Tlt8H+4Hv7j870zxSKHSOQqef0/CqzKcHZo7HUcx2yv3ltV+oY/BdtG07C2P1u2jj031hDba6+P0ffv8WX0/2ppO9Sjno/PDRR/dfHbSvpwCKVL1zc9UXbqfQ1/H+tG8ynNgy2p/x4sVvCmqvb799A33/zf/RB8wiu1L1747o/0VQpNDiPd7FuwAlO/ZfvNq9BVb9y1O2vD2oz6If/DgvBa7Ge60+ynIPWyqEIkV1mWKK937UIbaK/mHHv1WTrfkvXhVyp+BBsrn8yxwvRuxe/ff9iAqiSGm3OZ7hGvRVgunFtzvnJA6+ICgWcon6ZbLZ//WnmZ8Qfk30//2pcVEUqdG8c7U5DtkXv9zpi5UfknffFNEXBaLV3GXfV2NA9v+3mR9JmVgURQp1No90T+vC9UmSvtx9tVvGeQI5K/k5WiMi0L74OvMj2hfviSJV6mxVqap+m7ivjLFEshX81fdFbNYUvib64leZH6kTp4K83j+8KZIipTPT6wyO8bbtV/OsAizCnvHqj+0iboaFCA/+KicD7RP9f7+LK5QiVWEmV4kRLYJt2x9lz6VSn/7p9atXbz7+vE4tcmbLjhJxQuqXOS5aj9PYN5/vP2CxFCmhnVMPly6t8+X9D+1pXm3Uu4vJyuenFzCmGjDR+VP32Skq6JP7oDe+bh9AqGCK+VO7F6/q94ctCQ82546puoy+vMeDjVffrvIP1f36ozdvXn+7OARQ4RSvdgKgfug0YuUmM3gerAWj4buk/vaH7z5/sMELOrPsHpb2F08xb7Xs0nUwRQpNmNPHVMJ8Ht59e39l9stZmTqsDdbn8yucADic4jljqmr/8PzvpFXivTqUIoWWB7eiy9ExFCHHOc3f6JsjvveeKUKOs7m6CYCjKMKYannCbxzXh987RTwBcPiBL0LHUaRQ+/bY4Ig6x93/7v1TpEbM8romAI6kiP3NcTuORjdHrhdcAEWqfmW3bj+a4pFjqirzwOAwU5dA8dp2ABxPkRowhy83njDncxEUseVXlOOcQJEaRYO/fUKnzL9eCMUCZqseT6dQpITlQTmO0GmfcPBLoUhV2odM5l6ETqKI54335ziVfueUxnwxFB/YM3tpOpHiARMAp04RXA7FwxrrJehUirinPViJJ1fAJVG8ltnxkylSQnueHxyFycnbkS6KIp4BvoLgeDrFhzLQUfvm5LJfFkW8yHH5OwDOoJg/Ghyc44cujOJVTACcRZGqZp5v0T1rwHxpFM8tz2PoPIrUqL977tOxM61bujyKOMe57AmAMyniFYv0AdC8f9426wukSFU2Z329dJ1LcXv1sMJMzjzeJVI8b7tK+TqfIqURK/lHrepn6yIpXvgOgAIowpgqWlQt4myHC6V40TsAiqBICXN/V3UxbudSKeYk5BehQigGu01HN4WsAVwsRdxYL3R2vCCKeEylF5OOXy5FCi0Otu1xVRTF4uaNL5jixZ7mWBTFxUToF7OoetEUz5tcLE3FUBTm7RElFDOmumyK1Gh+gTsACqFYufWXb9C0iEXVC6dICcubi5sAKIJiEhKLGFNdOsVL3AFQAMUVEfGrtyfttSF1+RRP3oxSms6mKCxTs9/C2ddVuwKKxGzVZehciqPt7X5ocnuev7kGikE6dzk6k2LWrNSZY6qroEih5eaCdgCcRzF7FTz3iosH6TooXtYOgHMoorxrUuRe/fSgo14JRTwBcCnB8QyKQid3Vf+cXdVXQ3HvltzH0+kUHz5V8/RLx1wPRbxd5TIwnkxx3wD/5AurXxFFnMldxATAqRT3b2Co3pw2proqipS+uYQdAKdRhEHh/jx71D5pV/V1UaQGtxdwEcCTKI4OvLTPSRcBvDKKF3EKwCkUB5tDTwk/5bpq10aRQovN+94BcALFY87VP2FX9dVRvIAdAMdTPG4MUT/60jFXSPG9n+Z4LEWh3T8uCsCY6rhF1WukSNVPO/u9sJ8/jmKFOf6kzCPHVFdJkRKW7/MuAMdRPO3koeN2AFwnRTyp/P4mAI6ieGoUrx5zEcArpfheL3S8l+JguvhE96sLdQ6+M+K2hM7twdH0aikWsV3lRFVuHiRT7/z4088/v/uP7plb+I7YVX29FKl6u/0+JgAGyz98+fUy35+P2j998MHLlx+8/LF77laT6aH+5oop4gsdP/oEAHr7jX9N/Y9zHUHnZ2Do689n71E8bEwldNt/+fvn3YOq/PIovo8JgLfRvW1e59yCRPsxgvjyl1MuUpxWvb/f32h/fQc9/+W7vx7SpC+R4qPvABgk95m6z25An/wcQXz5wd/P9/io4++qFrTpVMsGUPnLL367+eCX/zggdb5IitTocW91/Da559ur7J722cuE4o9FbPnCs3fdP370+s0Xf8yMkv/3l7Dzf/DzP/Yf7TIp4jsdPeIuR/Iumn/IrJDPfiEoFjI1oTPz8G5TWXceHv059uAv/3N/TVwoxce909HXJMVMf7n6KanV/yrGTcT3mXtxv9sbuz8lrebdAZfuvFSKj3kNgK/u9vXFyo9xpf5cyE1tKeG75B6M/71Tr904JX75wU/7ByaXS5Ea9M+9YMyhIu6F+irnNxdhZ/zg5d+KcfXk3U7vd9yOnvT9D9494n2JS9CjneY4SvpF3i1rNQYSf9DPfyvI0X/6OqH4eqe31f+TiIv7c+JLpkhRy0cKjt3oBtJf5NyatMtMu//147t3f18WteryMEXqH08hR4108GzVmep+9+bu7u7Vt9mTKsFaizDQtOJWzh72qNTor9F48a9XO15MpD3SrY5Hn9z85nefZLtTtGSKH/agf08o/nfG+9X/wS785buDrgh46RQf705HQt42vApTyjJLN+6M99luvPsP5vt/HOaKLp7i7hUrS1Le+mJp3iC88/DdD8ucXdXXvKaxo9zTyopVDsXypuaR/vX969f3f9Dzrqv2pCgWc1/uvRIyp2677RJPlEV6t6vhOq3Pb7Kq9n8OTaaugiI1OPuKsVlCnkKqpWSombzaMlG9rApAQYdHrkX++P+zduxJK7LoKIrn3Rv7HNVLmB03myLHbosjxdO2FH1EtNXhaFDuLITZE1O20DsmYYv48G2eboxHAz8l20PRITXQnT065MbXpwktVxkW7Ve+RY7N07tiU1WmIpdmg9dtU7EqeqkUzf0WsQ0k26FFtDoUR/oBFF2xRkjiaztar4nnsjkqzedQgaGzXRMesOhD2amPsi0yJDaryoYGIfgmatj4dQ4gSla1VIoN6HwZFo23LKJUi/UhOuMafQjFXi3jsBxPtI2a3KpFDUhsuMNBtVynO8yyiCUtEt1ebFFNdceDQaZF8YFYHp4lXowm/JnacC3Or1neMhWeLbcvejwbdb4ci1jbUF2L5QPf4PTgyX6KjpXVweneMNG4AX5gHNaG6q09rdTIYWZaxLVIi2aJRWzDrXmDLIvMFh+2SB8B+nAAAAufSURBVNoaG7Idy7KS49o2Kwa9g7PMFgSpMimiXmARK9JWbyZbhEmJz4DnYvAXZ6tj/IW9FA067uAs4Xzs1jjWEFGm6in+R+iGx/PlUlTtxCLS+RAWjU2wyA0sYg1Z5DMpRgGIUwwHeqqZCA2JokZPoSdi6mVSNBUxrF7D3LLI43ctYiHV8r+wj6Icxg2WE3nb4sVYifsSh27TlvzWAe3ek+hyKcohOpYHixQx06Ke2wotoiVVFulMijM+rg1FpmQ71bHDBzGpO14J6rhEikmPAYvMRpZFkV/wX7LNcUD9YYpoHMUNy5uZlOzGkpWktfLRkVnOAYjlUhxK4a/aY7BolmMRz4WNj3dckc6kGAcgXB+8HSXuki+/WUiSoo7DVBAgOkoQikqj6HKJRRD2ojAoJhaJNasxjuBylhP634cpJiGx5UD/niVJUsONfi3leoIOXiJFUwkt4sYq/EWkbQ05ygrolEVuYNE2xSgAbYm1XDmW65lRKoh7YlgZZVFEcftMyyYskj3goCpcBDH0vw9SbCQhkaPHsi3yiaLeZ9t87AVs1fMNKY+imuQ1LN2UrQyLaNIiuiGLdBZFxwoqANxyqsq4XipDQnIzaBWihaKfJikKg65+wtRc/dO3bz/dWjqJQiLLb8FUvMQil0KzVmBR4k4fpijzZLPmwrSIFtekHDRToipT3cD/lkZRprm9Fn2oIqMVWlQzXZHOomj4IwdOEi3X5ZLIyqYG16JnSVLwg2IvyYsJip/87d1PP/3YP/I0PfT216/vXr3+7Vty7BOMErFFnkwnFnEpi3hsUVBo3kbNpAHmU2yFbYLdGha7ZOaEx8NeUKe06YVBtCyK0eBuyyKWtAh8IGSndmSRFFmUouj5AchuyVAAIta7SvrAXNRm+KapJHlxRFHo+HtwXr7881GT9KgTbtJ43U5edNnAIhcsMgiLWnkWKahJtOg8imEAAo9jWXGt+Y9E5mSrRsvm/A9ytjOMWms5FM2WGFpkKz5INjKJzOWMRs+OB8SuFFtEUERjKaBhYM9KzirT2eJb5Ag1prh6F21t+ssxS2bJBtSPPo1eG4Z5Ex7lKodYpJg9MhTkUFT9oRTH2uOG2UqGnqncFwdFkYuGn44XH7YUikGmxXH22DCHD1nER/OLjktYlFA0w5AIDtf27NREeHaVia04pwrqOpiBqyT7tn/pHF4O9Kdki8a/BD4VJRbRXpwsP2SRgnqp6JlNUfa7LoszIjRLMqSZm660OB/EEJNJsTIoNoLRzHDLIjmaFN62iJXMBCJJcSZJcUIk1vz0iOPzhN+pjdNzRZJb1XHtT4m9on8/fKVF+yih+IUfURtcbdui+MczJSlUi+yJ4rCSRTHKeVnoiXZSaF7Mmqf1IZpD4rAlUIwCHNtsmJZEFim7uYJFXsqiiCIyZsZxmiElBXFY6Xa7uq63ifOn3n2iH6rPkq3LL15PdF073iIDtUiL+F69G5xyRVI0FSkecHJ0qoNni7fMMXlY0S2YotmMLIL2eZBFNuFOsUVeNBvuKc0jpThk2+VbUGWLNuiWOPPm3a/ah+p7YgPqm+/b7aV8tEU9h1wM4JV6Vx9trxJDHLSOk5LqiTQHhy10TQOdYJFLxg3OGnVDimMxzZvj8H/Bk/CvrTXjtZOqMmGqB+7zRI9avSc2oOKxpittGRRZwCVWpUyC8CWRZXMiiCRF9Wilqwx6ZlcvdEX+BItmpEWsbepRQYepKRuOxumRH+wt/4MwDrPs9EQASZFTRnGVVcns5ohG+7v4nJ67G/x3ymnA79s2G+Rsdpx/W3RKJEXIxHW9Ev48QRHyzuNU88iqgbaRHLYQISVlEZ6RhxDN42epfxJJY7JqOLKgKYpcy3FMVUE2y1ow/oIaUcbwyjgVawmKrD0iyhadefPygz8fM9LQo9MIXnzsJzcpiqwMvz+cGTValB0IHp6KwwFKD2QJipCJExaRFFPfgOGZyPpTWv64EE/SiltJDk9SZGm1YIjUVhlYGOLZthW3UTym4pSU1RxJkbUbWuLhSYrQR4e2NaZRj+OGlCxxPbQ2FNpDqUw8ociyqQYq/OonfOLNBy//fNy5eZ9+E2xA/TYYLrqpLMy0bKU5RjzNOZTFiaorgpW5FIPajtnlUeRsT3Ztr8XhGUYRatDjLddNr9KSFFlWhSorNkFNl4F3KRM5TQp+q0e1OK5FWZBeUXIqMpMUeYO0KEVRMWmR5cSZIYmq6rCSbIgSx9Yoi/zBmCKUTe+mGmgwA3dz7IWyqv/7zf39r/837MAkRdGQ1xzrbylQTNUTJSApqbKZR1FMlS2PImdRxkz1ZEiKag7C3zIUU55R41TaRlAUyXZfkFIUuabJr2vWmlI4SYYaEF1nDe0WuXkUa8ZgSmTMKY/Kqk5T5PixSUN1wajQxO+K45y+yBk7DVTQuicVtz4YxJPhpOWsQskQllnVrXkNT5WaFCcOVSuvL0pbFuVQlKBt8BzbM20O92uONse2JdaMRirVTSiKxqDonrhLERcTGq0omrJZk2BIIcqyk0dRlAddctiTpkjLqAFFQ0rTrDlD24ROKDVTC/0JRXFWQtmorbjIKY7pcdA0P1SHlkm7Dcky7TyKvFtNlS2PIoRYHAltsyeOVcMVLYrmWLoGLiiT4s5hC1G6DKxhDiFGew5tm5CX2GZTbJmimUOR9yrdAbkGlM5RWdFuOOBmhvKs5jbGMDKUPDTMzFFrbnVayhx/OkfluB41hHrmTEs0m6pHm7I9RuOUdwgpirhsAukJciiytoo8kRUb8lp2x87aw+NNiELZHlUcVsoo6BZFbojA+VnI9hq8M+6ZNG0216ZLeoeYojgeTbXUrsp0X+RZrmY2JddUm7yCGq7ID02llp4OCigGVVZ42ajtvsixUs9kgZ3K1WYNk7YgYDuU2SMrPKAoDXHZUofKy27Y2th0bHFofkhZNuWvnPMK5WZmN+KwPh2UcPG2LX9C81Dr9Nocq+Oaa7jG2nE8D6lkOSOKAcTUwVLZjeUplufYrIIQfN6BWLtGrm1Zu3GR362yopQaFA17iqLKPAchn+fGyFxDTsVZSEmNCnyKYm/U1ba2/eaONGieMwzJQi0IR87YaXL8EKWm22KKfGv3sIVoiyIMDiGASa5j2nzTNFuiK89k5KTGrAFFPImkbc0/pCmayPR30zgNCaIHdOu1v++M3G/mU/Tn3Uq6umAqR8UJuAH+pgUtCgKZ/x6k0rtxkbPqXX3bolyKeFAPX1Idg+Nl02Q5BfXWfKppBBTxLJeeswH7PKUosk1jOG44ItukwLvzCMwVJQk86po02qfI+ZNIWxalPSreQY7LUsP+WML/+PsFUq0UKPKWUBrEtEfF2xawu+TWeJW/FqQfXC09QAeKkJFNd2s7L0dtODOD6kHSBMWHNNiAwEG5suySB/UpQpVNi513i5WmaBkN1T9rYjbkaNYLLOFnKf/gU2Rtp7s7/5DObg7R2sFzilopDRQrnd0cIttZ205Wl8nLbizP9WioLRuHQtaFbm7hjQQeeVBMMbPdF6St7AZPwOEnYjyhhG1ItVagyPtzU7sWjdNzz/vFrR0r80hFya0da5HtcGqmRbnZDR+snbNiVHGsGFUjQVG0sw9biLazm/3CfZHLngl095wKuCvLKXxOMaXZ0Rb1HEPTsyYb8rOb/QKKte25qSJ1EkV/WiPDIlSvHCuklQkRnWRR9owRQZHde1LZ9jlm3hC3jfLOQLHW+41IW9Rz5UF2QYVK9WgNSoQIFo2ONqgyyN4FTq4vHrt/wHDMwmfAU3Iax1uUP1uGjpZQJsRTDMqzKKGIRgPtSA2qepnnSKH6sQZpg0qpFl2qiL6I6kdrNCq1yi7PogvVMVdneNal6pniU9AzxaegZ4pPQc8Un4KeKT4FPVN8Cnqm+BT0TPEp6JniU9AzxaegZ4pPQc8Un4KeKT4FPVN8Cnqm+BT0TPEp6JniU9A/xwaH/w9UTXdBFUqcxQAAAABJRU5ErkJggg==)**

## Purpose of STP

- **Prevents Loops:** The primary function of STP is to eliminate switching loops that would otherwise result from redundant links between network switches.
- **Provides Redundancy:** By blocking redundant links, STP allows for a backup path to be available in case the primary active path fails, ensuring network resilience and preventing a single point of failure.

VMware works around STP by causing their virtual switches to operate in what is called “end-host mode,” meaning that the virtual switch does not participate in STP (newer versions of vSphere can, in fact, block STP BPDUs from being emitted), the virtual switch does not forward frames received on one uplink back out another uplink, and traffic from VMs is statically assigned (pinned) to an uplink. (This behavior is, of course, configurable.) Because of these default behaviors, users in VMware environments simply connect multiple links to their hosts and off they go.

Other environments behave differently. Environments using Open vSwitch (OVS), for example, need to use other methods to work around the presence of STP, especially considering that OVS is more a full-featured virtual switch than the standard VMware vSwitch. In most cases, the workaround involves the use of link aggregation; specifically, the use of Link Aggregation Control Protocol (LACP), a standardized protocol that allows devices to automatically negotiate the configuration and use of link aggregates comprised of multiple physical links.

Now that you have the background, let’s dive into the details of how to make this work. These instructions on using LACP with OVS do make a few assumptions:

1. First, I assume that OVS is already installed and working.

2. I assume that the management traffic to/from your host is not running through OVS, and thus won’t be interrupted by any configurations you do here. If this is not the case, and you do have management traffic running through OVS, you might want to exercise some additional caution to ensure you don’t accidentally cut your connectivity to the host.

3. I assume that you know how to configure your physical switch(es) to support LACP on the links coming in from OVS. The configuration will vary from switch vendor to switch vendor; refer to your vendor’s documentation for details.

This post was written using Ubuntu 12.04.1 LTS and Open vSwitch 1.4.0 (installed using apt-get directly from the Precise Pangolin repositories). The use of a different Linux distribution and/or a different version of OVS might make this process slightly different.

The first step is to add a bridge (substitute your desired bridge name for ovsbr1 in the following command):

`ovs-vsctl add-br ovsbr1`

Once the bridge is established, then you’ll need to create a bond. This is the actual link aggregate on OVS. The syntax for adding a bond looks something like this:

`ovs-vsctl add-bond <bridge name> <bond name> <list of interfaces>`

So, if you wanted to add a bond to ovsbr1 using physical interfaces eth1 and eth3, your command would look something like this:

`ovs-vsctl add-bond ovsbr1 bond0 eth1 eth3`

However, there’s a problem with this configuration: by default, LACP isn’t enabled on a bond. To fix this, you have two options.

1. Change the command use to create the bond, so that LACP is enabled when the bond is created.

2. Enable LACP after the bond is created.

For option #1, you’ll simply append lacp=active to the command to create the bond, like so:

`ovs-vsctl add-bond ovsbr1 bond0 eth1 eth3 lacp=active`

For option #2, you’d use ovs-vsctl set to modify the properties of the bond. Here’s an example:

`ovs-vsctl set port bond0 lacp=active`

Once the bond is created and LACP is enabled, you can check the configuration and/or status of the bond. Assuming that you’ve already configured your physical switch correctly, your bond should be working and passing traffic. You can use this command to see the status of the bond:

`ovs-appctl bond/show <bond name>`

The output from that command will look something like this:

```bash
bond_mode: balance-slb
bond-hash-algorithm: balance-slb
bond-hash-basis: 0
updelay: 0 ms
downdelay: 0 ms
next rebalance: 6415 ms
lacp_negotiated: true

slave eth4: enabled
    active slave
    may_enable: true

slave eth3: enabled
    may_enable: true

slave eth1: enabled
    may_enable: true

slave eth2: enabled
    may_enable: true
```

This command will show more detailed LACP-specific information:

`ovs-appctl lacp/show <bond name>`

This command returns a great deal of information; here’s a quick snippet:

```bash
---- bond0 ----
    status: active negotiated
    sys_id: 00:22:19:bd:db:dd
    sys_priority: 65534
    aggregation key: 4
    lacp_time: fast

slave: eth1: current attached
    port_id: 4
    port_priority: 65535

    actor sys_id: 00:22:19:bd:db:dd
    actor sys_priority: 65534
    actor port_id: 4
    actor port_priority: 65535
    actor key: 4
    actor state: activity timeout aggregation synchronized collecting<br></br>distributing

    partner sys_id: 00:12:f2:cc:6d:40
    partner sys_priority: 1
    partner port_id: 12
    partner port_priority: 1
    partner key: 10000
    partner state: activity aggregation synchronized collecting<br></br>distributing
```

You can also use this command to view the configuration details of the bond:

`ovs-vsctl list port bond0`

```bash
ovs-vsctl list port
_uuid               : 151765e0-dc70-43d6-a265-a8005b0d0ea7
bond_active_slave   : []
bond_downdelay      : 0
bond_fake_iface     : false
bond_mode           : []
bond_updelay        : 0
cvlans              : []
external_ids        : {}
fake_bridge         : false
interfaces          : [8d368b97-279e-4c96-a5b7-96f53e9dc00e]
lacp                : []
mac                 : []
name                : veth4338d9e7
other_config        : {}
protected           : false
qos                 : []
rstp_statistics     : {}
rstp_status         : {}
statistics          : {}
status              : {}
tag                 : []
trunks              : []
vlan_mode           : []
_uuid               : 2744fa28-27fd-4245-bc49-63c88c0aa1f5
bond_active_slave   : []
bond_downdelay      : 0
bond_fake_iface     : false
bond_mode           : []
bond_updelay        : 0
cvlans              : []
external_ids        : {}
fake_bridge         : false
interfaces          : [c7591136-ac91-45e6-a6c4-612ec84bc5eb]
lacp                : []
mac                 : []
name                : lxdovn1
other_config        : {}
protected           : false
qos                 : []
rstp_statistics     : {}
rstp_status         : {}
statistics          : {}
status              : {}
tag                 : []
trunks              : []
vlan_mode           : []

...
```

The output from this command will look something like this:

```bash
_uuid               : ae7eb7ca-e3e0-4166-bcfb-4348071799e0
bond_downdelay      : 0
bond_fake_iface     : false
bond_mode           : []
bond_updelay        : 0
external_ids        : {}
fake_bridge         : false
interfaces          : [9963381b-6a7d-4a8f-acf8-86150361530e,bee2df86-ed14-456b-8f3a-25fb00fa6040,daf5ac51-4135-4e3c-a937-c62dfc4b5e9f,fcd2d6ef-9a18-452a-9a79-1c97e5a95ef2]
lacp                : active
mac                 : []
name                : "bond0"
other_config        : {lacp-time=fast}
qos                 : []
statistics          : {}
status              : {}
tag                 : []
trunks              : []
vlan_mode           : []
```

In learning how to use LACP with OVS, I found this **[article](http://brezular.com/2011/12/04/openvswitch-playing-with-bonding-on-openvswitch/)** to be extremely helpful.

If you have questions, or have additional information to share with me and/or other readers, please speak up in the comments. Thanks!
