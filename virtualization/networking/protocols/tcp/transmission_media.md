# **[Types of Transmission Media](https://www.geeksforgeeks.org/types-transmission-media/)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

## Types of Transmission Media

Last Updated : 31 Jul, 2024
Transmission media refer to the physical pathways through which data is transmitted from one device to another within a network. These pathways can be wired or wireless. The choice of medium depends on factors like distance, speed, and interference. In this article, we will discuss the transmission media.

## What is Transmission Media?

A transmission medium is a physical path between the transmitter and the receiver i.e. it is the channel through which data is sent from one place to another. Transmission Media is broadly classified into the following types:

![](https://media.geeksforgeeks.org/wp-content/uploads/20240731120431/Types-of-Transmission-Media.png)

## 1. Guided Media

**[Guided Media](https://www.geeksforgeeks.org/wired-communication-media/)** is also referred to as Wired or Bounded transmission media. Signals being transmitted are directed and confined in a narrow pathway by using physical links.
Features:  

- High Speed
- Secure
- Used for comparatively shorter distances

There are 3 major types of Guided Media:

## Twisted Pair Cable

It consists of 2 separately insulated conductor wires wound about each other. Generally, several such pairs are bundled together in a protective sheath. They are the most widely used Transmission Media. Twisted Pair is of two types:

**Unshielded Twisted Pair (UTP):** UTP consists of two insulated copper wires twisted around one another. This type of cable has the ability to block interference and does not depend on a physical shield for this purpose. It is used for telephonic applications.

## Advantages of Unshielded Twisted Pair

- Least expensive
- Easy to install
- High-speed capacity

## Disadvantages of Unshielded Twisted Pair

- Susceptible to external interference
- Lower capacity and performance in comparison to STP
- Short distance transmission due to attenuation

**Shielded Twisted Pair (STP):** This type of cable consists of a special jacket (a copper braid covering or a foil shield) to block external interference. It is used in fast-data-rate Ethernet and in voice and data channels of telephone lines.

## Advantages of Shielded Twisted Pair

- Better performance at a higher data rate in comparison to UTP
- Eliminates crosstalk
- Comparatively faster

**Crosstalk** is a disturbance caused by the electric or magnetic fields of one telecommunication signal affecting a signal in an adjacent circuit.

## Disadvantages of Shielded Twisted Pair

- Comparatively difficult to install and manufacture
- More expensive
- Bulky

## Coaxial Cable

It has an outer plastic covering containing an insulation layer made of PVC or Teflon and 2 parallel conductors each having a separate insulated protection cover. The coaxial cable transmits information in two modes: Baseband mode(dedicated cable bandwidth) and Broadband mode(cable bandwidth is split into separate ranges). Cable TVs and analog television networks widely use Coaxial cables.

![](https://media.geeksforgeeks.org/wp-content/uploads/20211109184950/UntitledDiagram72-300x156.png)

## Advantages of Coaxial Cable

- Coaxial cables support high bandwidth.
- It is easy to install coaxial cables.
- Coaxial cables have better cut-through resistance so they are more reliable and durable.
- Less affected by noise or cross-talk or electromagnetic inference.
- Coaxial cables support multiple channels

## Disadvantages of Coaxial Cable

- Coaxial cables are expensive.
- The coaxial cable must be grounded in order to prevent any crosstalk.
- As a Coaxial cable has multiple layers it is very bulky.
- There is a chance of breaking the coaxial cable and attaching a “t-joint” by hackers, this compromises the security of the data.

## Optical Fiber Cable

**[Optical Fibre Cable](https://www.geeksforgeeks.org/optical-fibre-cable/)** uses the concept of refraction of light through a core made up of glass or plastic. The core is surrounded by a less dense glass or plastic covering called the cladding. It is used for the transmission of large volumes of data. The cable can be unidirectional or bidirectional. The **[WDM (Wavelength Division Multiplexer)](https://www.geeksforgeeks.org/difference-between-wdm-and-dwdm/)** supports two modes, namely unidirectional and bidirectional mode.

![](https://media.geeksforgeeks.org/wp-content/uploads/20210716190121/UntitledDiagram62-300x196.png)

## Advantages of Optical Fibre Cable

- Increased capacity and bandwidth
- Lightweight
- Less signal attenuation
- Immunity to electromagnetic interference
- Resistance to corrosive materials

## Disadvantages of Optical Fibre Cable

- Difficult to install and maintain
- High cost
- Fragile

## Applications of Optical Fibre Cable

- Medical Purpose: Used in several types of medical instruments.
- Defence Purpose: Used in transmission of data in aerospace.
- For Communication: This is largely used in formation of internet cables.
- Industrial Purpose: Used for lighting purposes and safety measures in designing the interior and exterior of automobiles.

## Stripline

Stripline is a transverse electromagnetic (TEM) transmission line medium invented by Robert M. Barrett of the Air Force Cambridge Research Centre in the 1950s. Stripline is the earliest form of the planar transmission line. It uses a conducting material to transmit high-frequency waves it is also called a waveguide. This conducting material is sandwiched between two layers of the ground plane which are usually shorted to provide EMI immunity.

## Microstripline

In this, the conducting material is separated from the ground plane by a layer of dielectric.

## 2. Unguided Media

It is also referred to as Wireless or Unbounded transmission media. No physical medium is required for the transmission of electromagnetic signals.

## Features of Unguided Media

- The signal is broadcasted through air
- Less Secure
- Used for larger distances

There are 3 types of Signals transmitted through unguided media:

## Radio Waves

Radio waves are easy to generate and can penetrate through buildings. The sending and receiving antennas need not be aligned. Frequency Range:3KHz – 1GHz. AM and FM radios and cordless phones use Radio waves for transmission.

![](https://media.geeksforgeeks.org/wp-content/uploads/20210716190536/radiowave3-300x164.png)

Further Categorized as Terrestrial and Satellite.

## Microwaves

It is a line of sight transmission i.e. the sending and receiving antennas need to be properly aligned with each other. The distance covered by the signal is directly proportional to the height of the antenna. Frequency Range:1GHz – 300GHz. Micro waves are majorly used for mobile phone communication and television distribution.

![](https://media.geeksforgeeks.org/wp-content/uploads/20230305154947/download.png)

Cell-phones, Wi-Fi, GPS, Bluetooth and many other technologies use microwaves to enable much in modern life. It's worth getting to know them a little. Microwaves are a form of electromagnetic (EM) radiation: just like gamma rays, x-rays, ultraviolet radiation, visible light, infrared radiation and radio waves.

## Infrared

Infrared waves are used for very short distance communication. They cannot penetrate through obstacles. This prevents interference between systems. Frequency Range:300GHz – 400THz. It is used in TV remotes, wireless mouse, keyboard, printer, etc.

![](https://media.geeksforgeeks.org/wp-content/uploads/20210716190816/infrared1-227x300.png)

## Difference Between Radio Waves Vs Micro Waves Vs Infrared Waves

| Basis              | Radiowave                                                                                                             | Microwave                                                                                                       | Infrared wave                                              |
|--------------------|-----------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|------------------------------------------------------------|
| Direction          | These are omni-directional in nature.                                                                                 | These are unidirectional in nature.                                                                             | These are unidirectional in nature.                        |
| Penetration        | At low frequency, they can penetrate through solid objects and walls but high frequency they bounce off the obstacle. | At low frequency, they can penetrate through solid objects and walls. at high frequency, they cannot penetrate. | They cannot penetrate through any solid object and walls.  |
| Frequency range    | Frequency range: 3 KHz to 1GHz.                                                                                       | Frequency range: 1 GHz to 300 GHz.                                                                              | Frequency range: 300 GHz to 400 GHz.                       |
| Security           | These offers poor security.                                                                                           | These offers medium security.                                                                                   | These offers high security.                                |
| Attenuation        | Attenuation is high.                                                                                                  | Attenuation is variable.                                                                                        | Attenuation is low.                                        |
| Government License | Some frequencies in the radio-waves require government license to use these.                                          | Some frequencies in the microwaves require government license to use these.                                     | There is no need of government license to use these waves. |
| Usage Cost         | Setup and usage Cost is moderate.                                                                                     | Setup and usage Cost is high.                                                                                   | Usage Cost is very less.                                   |
| Communication      | These are used in long distance communication.                                                                        | These are used in long distance communication.                                                                  | These are not used in long distance communication.         |

In physics, attenuation is the gradual loss of flux intensity through a medium. For instance, dark glasses attenuate sunlight, lead attenuates X-rays, and water and air attenuate both light and sound at variable attenuation rates. Hearing protectors help reduce acoustic flux from flowing into the ears.

Flux intensity, or intensity, is a measure of the power transferred per unit area in physics and other areas of science and engineering. The area is measured on a plane perpendicular to the direction of the energy's propagation. Flux and intensity are closely related and are central to many problems in atmospheric science.
