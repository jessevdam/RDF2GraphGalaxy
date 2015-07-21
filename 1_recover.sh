
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
simplify=$4
removeOWL=$5
if [ "$simplify" = "true" ] ; then
  simplify="--executeSimplify"
else
  simplify=""
fi

if [ "$removeOWL" = "true" ] ; then
  removeOWL="--removeOWLClasses"
else
  removeOWL=""
fi

size=$( cat $input | wc -l )

if [ $size -ge 20000000 ] ; then
  echo "number of lines limited to 20.000.000" 1>&2;
  echo "nubmer of lines in file $size" 1>&2;
  exit
fi

java -jar $DIR/programs/RDF2Graph/target/RDF2Graph-0.1-jar-with-dependencies.jar temp file://$input{$extension} --all $removeOWL $simplify
tdbquery --loc temp --query $DIR/programs/RDF2Graph/rdfExporter/queries/all.txt --results N3 > $output
#$DIR/programs/RDF2Graph/rdfExporter temp $output

