import ants
import antspynet
import sys

import os.path
from os import path

import tensorflow as tf


####################
#
# Set-up
#
####################

output_prefix = sys.argv[1]
threads = int(sys.argv[2])
t1_files = sys.argv[3:]

tf.keras.backend.clear_session()
config = tf.compat.v1.ConfigProto(intra_op_parallelism_threads=threads,
                                  inter_op_parallelism_threads=threads)
session = tf.compat.v1.Session(config=config)
tf.compat.v1.keras.backend.set_session(session)

####################
#
# Read in t1 files
#
####################

t1s = list()
for i in range(len(t1_files)):
    print("Reading", t1_files[i])
    t1s.append(ants.image_read(t1_files[i]))

####################
#
# Run cross-sectional antsxnet KK and DKT
#
####################

print("Cross-sectional cortical thickness and DKT")

for i in range(len(t1s)):
    kk_file =
    kk = antspynet.cortical_thickness(t1, verbose=True)
    ants.image_write(kk['thickness_image'], kk_file)

    dkt_file =
    dkt = antspynet.desikan_killiany_tourville_labeling(t1, do_preprocessing=True, verbose=True)
    ants.image_write(dkt, dkt_file)

    dkt_prop_file =
    dkt_mask = ants.threshold_image(dkt, 1000, 3000, 1, 0)
    dkt = dkt_mask * dkt
    ants_tmp = ants.threshold_image(kk['thickness_image'], 0, 0, 0, 1)
    ants_dkt = ants.iMath(ants_tmp, "PropagateLabelsThroughMask", ants_tmp * dkt)
    ants.image_write(ants_dkt, dkt_prop_file)


####################
#
# Run longitudinal cortical thickness
#
####################

print("Longitudinal cortical thickness and DKT")

kk_long = antspynet.longitudinal_cortical_thickness(t1s, initial_template="adni",
  number_of_iterations=2, refinement_transform="antsRegistrationSyNQuick[a]", verbose=True)

sst_file =
ants.image_write(kk_long[-1], sst_file)

for i in range(len(t1s)):
    kk_file =
    ants.image_write(kk_long[i]['thickness_image'], kk_file)

    dkt_file =
    dkt = antspynet.desikan_killiany_tourville_labeling(t1s[i], do_preprocessing=True, verbose=True)
    ants.image_write(dkt, dkt_file)

    dkt_prop_file =
    dkt_mask = ants.threshold_image(dkt, 1000, 3000, 1, 0)
    dkt = dkt_mask * dkt
    ants_tmp = ants.threshold_image(kk['thickness_image'], 0, 0, 0, 1)
    ants_dkt = ants.iMath(ants_tmp, "PropagateLabelsThroughMask", ants_tmp * dkt)
    ants.image_write(ants_dkt, dkt_prop_file)
