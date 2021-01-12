#!/bin/bash

nuget_project_name="Laerdal.Xamarin.FFmpeg.Android"
nuget_output_folder="$nuget_project_name.Output"

usage(){
    echo "usage: ./build.sh [-p|--package [audio|full|full-gpl|https|https-gpl|min|min-gpl|video]] [-r|--revision build_revision] [-c|--clean-output] [-v|--verbose]"
    echo "parameters:"
    echo "  -p | --package [audio|full|full-gpl|https|https-gpl|min|min-gpl|video]    Multiple -p paramaters can be added. See https://github.com/tanersener/mobile-ffmpeg for more information"
    echo "  -r | --revision [build_revision]                                          Sets the revision number, default = mdd.hMMSS"
    echo "  -c | --clean-output                                                       Cleans the output before building"
    echo "  -v | --verbose                                                            Enable verbose build details from msbuild tasks"
    echo "  -h | --help                                                               Prints this message"
    echo
}

while [ "$1" != "" ]; do
    case $1 in
        -p | --package )        shift
                                package_variants="${package_variants} $1"
                                ;;
        -r | --revision )       shift
                                build_revision=$1
                                ;;
        -c | --clean-output )   clean_output=1
                                ;;
        -v | --verbose )        verbose=1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     echo
                                echo "### Wrong parameter: $1 ###"
                                echo
                                usage
                                exit 1
    esac
    shift
done

if [ -z "$build_revision" ]; then
    build_revision=`date +%-m%d.%-H%M%S`
fi

if [ "$clean_output" = "1" ]; then
    echo ""
    echo "### CLEAN OUTPUT ###"
    echo ""

    rm -rf $nuget_output_folder
    echo "Deleted : $nuget_output_folder"
fi


echo ""
echo "### LOOP ###"
echo ""

if [ -z "$package_variants" ]; then
    package_variants="audio full full-gpl https https-gpl min min-gpl video"
fi

echo "package_variants : $package_variants"

for package_variant in $package_variants
do 
    . ./build.single.sh
done