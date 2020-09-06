import ants
import antspynet
import sys

import tensorflow as tf

t1_file = sys.argv[1]
output_prefix = sys.argv[2]
threads = int(sys.argv[3])

tf.keras.backend.clear_session()
config = tf.compat.v1.ConfigProto(intra_op_parallelism_threads=threads,
                                  inter_op_parallelism_threads=threads)
session = tf.compat.v1.Session(config=config)
tf.compat.v1.keras.backend.set_session(session)

t1 = ants.image_read( t1_file )
kk = ants.image_read( output_prefix + "CorticalThickness.nii.gz" )

# If one wants cortical labels one can run the following lines

dkt = antspynet.desikan_killiany_tourville_labeling( t1, do_preprocessing = True, verbose = True )
ants.image_write( dkt, output_prefix + "Dkt.nii.gz" )

dkt_mask = ants.threshold_image( dkt, 1000, 3000, 1, 0 )
dkt = dkt_mask * dkt
ants_tmp = ants.threshold_image( kk, 0, 0, 0, 1 )
ants_dkt = ants.iMath( ants_tmp, "PropagateLabelsThroughMask", ants_tmp * dkt )

ants.image_write( ants_dkt, output_prefix + "DktPropagatedLabels.nii.gz" )
#
