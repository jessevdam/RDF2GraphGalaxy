
#directory change source from http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

input=$1 
extension=$2
output=$3

size=$( cat $input | wc -l )
if [ $size -ge 20000000 ] ; then
  echo "number of lines limited to 20.000.000" 1>&2;
  echo "nubmer of lines in file $size" 1>&2;
  exit
fi

cp $input $input"."$extension
tdbloader -loc ./tempdb --graph=http://ssb.wur.nl/RDF2Graph/ $input"."$extension
$DIR/programs/RDF2Graph/shexExporter/export.sh ./tempdb $output

