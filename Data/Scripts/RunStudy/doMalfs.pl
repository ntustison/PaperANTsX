#/usr/bin/perl -w

use strict;

use Cwd 'realpath';
use Switch;
use File::Find;
use File::Basename;
use File::Path;
use File::Spec;
use FindBin qw($Bin);


my $baseDirectory = "/pub/ntustiso/Data/SRPB1600/";
my $t1Directory = "${baseDirectory}/data/";

my @suffixList = ( ".nii.gz" );

my @subjects = <${t1Directory}/sub*/t1/defaced_mprage.nii.gz>;
my @suffixList = ( ".nii.gz" );

my $templateDirectory = "/pub/ntustiso/Data/Template30/";
my $ANTSPATH = "/data/users/ntustiso/Pkg/ANTs/bin/bin/";

my $brainExtractionTemplate = "${templateDirectory}/T_template.nii.gz";
my $brainTemplate = "${templateDirectory}/T_template_BrainCerebellum.nii.gz";
my $brainExtractionProbabilityMask = "${templateDirectory}/T_template_BrainCerebellumProbabilityMask.nii.gz";
my $brainExtractionRegistrationMask = "${templateDirectory}/T_template_BrainCerebellumExtractionMask.nii.gz";
my $brainPriors = "${templateDirectory}/Priors2/priors%d.nii.gz";

my $template = '/dfs2/yassalab/ANTs_JLF_Data_folder/Hippocampus/StarkTrainingSet/Template/T_template0.nii.gz';
my $atlasDirectory = '/dfs2/yassalab/ANTs_JLF_Data_folder/Hippocampus/StarkTrainingSet/Nifti/';
my @atlasT2Images = <${atlasDirectory}/S*//T2_struct.nii.gz>;

my $count = 0;
for( my $i = 0; $i < @subjects; $i++ )
  {
  my $image = ${subjects[$i]};

  my ( $filename, $path, $suffix ) = fileparse( $image, ".nii.gz" );

  ( my $outputDir = $path ) =~ s/data/processed/;
  if( ! -d $outputDir )
    {
    mkpath( $outputDir );
    }

  my $prefix = "${outputDir}/ants";

  print "$prefix\n";

  my $commandFile = "${prefix}JlfCommand.sh";
  open( FILE, ">${commandFile}" );
  print FILE "#!/bin/sh\n";
  print FILE "export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=2\n";
  print FILE "export ANTSPATH=${ANTSPATH}\n";
  print FILE "export LD_LIBRARY_PATH=/data/apps/gcc/4.8.2/lib64:\$LD_LIBRARY_PATH\n";

  my $n4 = "${prefix}BrainExtractionN4.nii.gz";
  if( ! -e $n4 )
    {
    print FILE "${ANTSPATH}/N4BiasFieldCorrection -d 3 -v 1 -o $n4 -i $image -s 4 -c [50x50x50x50,0.0] -b 200\n";
    }

  my $mask = "${prefix}BrainExtractionMask.nii.gz";
  if( ! -e $mask )
    {
    print FILE "${ANTSPATH}/antsBrainExtraction.sh -d 3 -a $n4 -e $brainExtractionTemplate -m $brainExtractionProbabilityMask -o ${prefix}\n";
    }

  my $templateRegPrefix = "${prefix}xtemplate";

  my $subjectWarp = "${templateRegPrefix}1Warp.nii.gz";
  my $subjectInverseWarp = "${templateRegPrefix}1InverseWarp.nii.gz";
  my $subjectAffine = "${templateRegPrefix}0GenericAffine.mat";
  my $subjectMalf = "${prefix}JlfLabels.nii.gz";

  my $brainExtracted = "${prefix}BrainExtractionBrain.nii.gz";
  if( ! -e $brainExtracted )
    {
    print FILE "${ANTSPATH}/ImageMath 3 $brainExtracted m $n4 $mask\n\n"  ;
    }

  my $brainDenoised = "${prefix}BrainExtractionBrainDenoised.nii.gz";
  if( ! -e $brainDenoised )
    {
    print FILE "${ANTSPATH}/DenoiseImage -d 3 -i $brainExtracted -o $brainDenoised -v 1\n\n";
    }

  if( ! -e $subjectWarp )
    {
    print FILE "${ANTSPATH}/antsRegistrationSyNQuick.sh -n 4 -d 3 -m $template -f $brainDenoised -t b -o $templateRegPrefix\n\n";
    }

  my $warpedPrefix = "${prefix}JlfWarped";

  my @warpedImages = <${warpedPrefix}*.nii.gz>;
  if( @warpedImages > 0 )
    {
    next;
    }

  my @warpedLabels = ();
  my @warpedBrains = ();

  for( my $j = 0; $j < @atlasT2Images; $j++ )
    {
    my ( $atlasFilename, $atlasPath, $atlasSuffix ) = fileparse( ${atlasT2Images[$j]}, ".nii.gz" );
    my $structxT2Affine = "${atlasPath}/structxT20GenericAffine.mat";
    my $template0xstructAffine = "${atlasPath}/T_template0xstruct_0GenericAffine.mat";
    my $template0xstructWarp = "${atlasPath}/T_template0xstruct_1Warp.nii.gz";
    my $template0xstructInverseWarp = "${atlasPath}/T_template0xstruct_1InverseWarp.nii.gz";

    my @tmp = <${atlasPath}/*ROIsub.nii.gz>;
    my $labels = $tmp[0];
    my $brain = "${atlasPath}/struct.nii.gz";

    if( ! -e $brain || ! -e $labels || ! -e $structxT2Affine || ! -e $template0xstructAffine || ! -e $template0xstructWarp )
      {
      next;
      }

    my @args = ( "${ANTSPATH}/antsApplyTransforms",
                    '-d', 3, '-v', '1',
                    '-r', $brainDenoised,
                    '-i', $labels,
                    '-n', 'GenericLabel[Linear]',
                    '-o', "${warpedPrefix}Labels${j}.nii.gz",
                    '-t', $subjectWarp,
                    '-t', $subjectAffine,
                    '-t', $template0xstructWarp,
                    '-t', $template0xstructAffine,
                    '-t', $structxT2Affine
               );
    if( ! -e "${warpedPrefix}Labels${j}.nii.gz" )
      {
      print FILE "@args\n";
      }
    @args = ( "${ANTSPATH}/antsApplyTransforms",
                    '-d', 3, '-v', '1',
                    '-r', $brainDenoised,
                    '-i', $brain,
                    '-n', 'Linear',
                    '-o', "${warpedPrefix}Brain${j}.nii.gz",
                    '-t', $subjectWarp,
                    '-t', $subjectAffine,
                    '-t', $template0xstructWarp,
                    '-t', $template0xstructAffine
               );
    if( ! -e "${warpedPrefix}Brain${j}.nii.gz" )
      {
      print FILE "@args\n";
      }

    print FILE "${ANTSPATH}/CopyImageHeaderInformation ${brainDenoised} ${warpedPrefix}Labels${j}.nii.gz ${warpedPrefix}Labels${j}.nii.gz 1 1 1\n";
    print FILE "${ANTSPATH}/CopyImageHeaderInformation ${brainDenoised} ${warpedPrefix}Brain${j}.nii.gz ${warpedPrefix}Brain${j}.nii.gz 1 1 1\n";

    push( @warpedLabels, "${warpedPrefix}Labels${j}.nii.gz" );
    push( @warpedBrains, "${warpedPrefix}Brain${j}.nii.gz" );
    }

  my $jlfMask = "${warpedPrefix}Mask.nii.gz";

  if( ! -e $jlfMask )
    {
    print FILE "cp ${warpedLabels[0]} $jlfMask\n";
    for( my $k = 1; $k < @warpedBrains; $k++ )
      {
      print FILE "${ANTSPATH}/ImageMath 3 $jlfMask + $jlfMask ${warpedLabels[$k]}\n";
      }
    print FILE "${ANTSPATH}/ThresholdImage 3 $jlfMask $jlfMask 0 0 0 1\n";
    print FILE "${ANTSPATH}/ImageMath 3 $jlfMask MD $jlfMask 5\n\n\n";
    }

  print FILE "${ANTSPATH}/CopyImageHeaderInformation $brainDenoised $jlfMask $jlfMask 1 1 1\n";

  my @jlfArgs = ( "${ANTSPATH}/antsJointFusion",
                            '-d', '3', '-v', '1', '-c', 1,
                            '-o', $subjectMalf,
                            '-t', $brainDenoised,
                            '-x', $jlfMask
                );
  for( my $k = 0; $k < @warpedBrains; $k++ )
    {
    push( @jlfArgs, '-g', ${warpedBrains[$k]}, '-l', ${warpedLabels[$k]} );
    }

  print FILE "@jlfArgs\n";

  my @templateRegPrefixFiles = <${templateRegPrefix}*>;

  print FILE "rm -f @warpedBrains\n";
  print FILE "rm -f @warpedLabels\n";
  print FILE "rm -f $jlfMask\n";
  print FILE "rm -f @templateRegPrefixFiles\n";
  close( FILE );

  print "$commandFile\n";

  if( ! -e ${subjectMalf} )
    {
    $count++;
    print "** SRPBJLF ${subjectMalf}\n";

    # bio
    system( "qsub -N srpbjlf_${i} -q yassalab,abio,asom,som,pub64,pub8i,free64 -ckpt restart $commandFile" );

    sleep 2s;
    }
  }

print "Processing $count files.\n";
