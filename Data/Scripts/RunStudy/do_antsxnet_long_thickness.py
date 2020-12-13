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

output_directory = sys.argv[1]
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
t1s_basename_prefix = list()
for i in range(len(t1_files)):
    print("Reading", t1_files[i])
    t1s.append(ants.image_read(t1_files[i]))
<<<<<<< HEAD
    t1s_basename_prefix.append(t1_files[i].replace('.nii.gz', ''))
=======
    t1_basename = os.path.basename(t1_files[i])
    t1s_basename_prefix.append(t1_basename.replace('.nii.gz', ''))
>>>>>>> d992129e94f089481a8f930f83dac7f8638ed8d4

####################
#
# Run longitudinal cortical thickness
#
####################

kk_long = antspynet.longitudinal_cortical_thickness(t1s, initial_template="adni",
  number_of_iterations=2, refinement_transform="antsRegistrationSyNQuick[a]", verbose=True)

<<<<<<< HEAD
sst_file = output_directory + "/" + t1s_basename_prefix[i] + "SingleSubjectTemplate.nii.gz"
=======
sst_file = output_directory + "/" + "SingleSubjectTemplate.nii.gz"
>>>>>>> d992129e94f089481a8f930f83dac7f8638ed8d4
ants.image_write(kk_long[-1], sst_file)

for i in range(len(t1s)):
    kk_file = output_directory + "/" + t1s_basename_prefix[i] + "CorticalThickness.nii.gz"
    ants.image_write(kk_long[i]['thickness_image'], kk_file)

    t1_pre_file = output_directory + "/" + t1s_basename_prefix[i] + "Preprocessed.nii.gz"
    ants.image_write(kk_long[i]['preprocessed_image'], t1_pre_file)

<<<<<<< HEAD
    dkt_file = output_directory + "/" + t1s_basename_prefix[i] + "Dkt.nii.gz"
    dkt = antspynet.desikan_killiany_tourville_labeling(kk_long[i]['preprocessed_image'], do_preprocessing=True, verbose=True)
    ants.image_write(dkt, dkt_file)

    dkt_prop_file = output_directory + "/" + t1s_basename_prefix[i] + "DktPropagated.nii.gz"
=======
    dkt_file = output_directory + "/" + t1s_basename_prefix[i] + "DktLabels.nii.gz"
    dkt = antspynet.desikan_killiany_tourville_labeling(kk_long[i]['preprocessed_image'], do_preprocessing=True, verbose=True)
    ants.image_write(dkt, dkt_file)

    dkt_prop_file = output_directory + "/" + t1s_basename_prefix[i] + "DktPropagatedLabels.nii.gz"
>>>>>>> d992129e94f089481a8f930f83dac7f8638ed8d4
    dkt_mask = ants.threshold_image(dkt, 1000, 3000, 1, 0)
    dkt = dkt_mask * dkt
    ants_tmp = ants.threshold_image(kk_long[i]['thickness_image'], 0, 0, 0, 1)
    ants_dkt = ants.iMath(ants_tmp, "PropagateLabelsThroughMask", ants_tmp * dkt)
    ants.image_write(ants_dkt, dkt_prop_file)
