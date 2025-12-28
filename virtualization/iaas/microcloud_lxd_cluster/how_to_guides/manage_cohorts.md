# **[cohorts](https://forum.snapcraft.io/t/managing-cohorts/8995)**

The store is growing the capability of capturing a view/snapshot at a given point in history of the channelmap for each of a set of snaps, called a cohort, fixing a corresponding set of revisions for those snaps given other constraints (e.g. channel, architecture). The cohort is then identified per snap by an opaque key that works across systems. Installations or refreshes of the snap using a given cohort key would use the fix revision for a up to 90 days period, after which a new set of revisions would be fixed under that same cohort key and a new 90 days window started.

There is a small UX challenge in that we expect cohort keys to be somewhat long (>80 chars long). While we should not make the feature unapproachable for human users, we would typically expect it to be driven by software/scripts.

The following features will be implemented in snapd 2.40.

Installing or refreshing a snap in a cohort by key
snap install --cohort=<cohort-key> <snap>
snap refresh --cohort=<cohort-key> <snap>
This would work like --channel in that the cohort key would also become sticky for the given snap. Most other install/refresh options can be combined with this except --revision.

Leaving/changing cohort
To stop snap from belonging to a cohort for subsequent operations:

snap switch --leave-cohort <snap>
To both stop a snap from belonging to a cohort and refresh it outside of it:

snap refresh --leave-cohort <snap>...
Changing cohort for subsequent operations:

snap switch --cohort=<cohort-key> <snap>
Creating a cohort for snaps possibly not yet on the system
snap create-cohort <snap-name>...
Output would be YAML-parseable of the form:

cohort:
    <snap-name>:
       cohort-key:  <cohort-key>
…
This is does not directly affect the state of the system.

Querying about cohorts
snap info will show whether the snap on a system belongs to a cohort (in-cohort will be mentioned in the notes on the installed entry). snap info --verbose will also print the cohort-key when set.

Future work (not planned for 2.40):
To find out what a snap would refresh to in a cohort this can be used:

snap refresh --list --cohort=<cohort-key> <snap>
