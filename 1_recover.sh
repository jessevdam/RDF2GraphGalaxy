
#directory change source from http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

source_select=$1
input=$2
extension=$3
endpoint_adress=$4
graph=$5
username=$6 
password=$7
output=$8
simplify=$9
removeOWL=$10
isDocker=0

if [ "$simplify" = "true" ] ; then
  simplify="--executeSimplify"
else
  simplify=""
fi

if [ "$removeOWL" = "true" ] ; then
  removeOWL="--removeOWLProperties"
else
  removeOWL=""
fi

graph_adress=""

if [ "$source_select" = "file" ] ; then
  size=$( cat $input | wc -l )
  if [[ $isDocker == 0 && $size -ge 20000000 ]] ; then
    echo "number of lines limited to 20.000.000" 1>&2;
    echo "nubmer of lines in file $size" 1>&2;
    exit
  fi
  graph_adress=file://$input{$extension}
else
  if [[ ("$graph" != "") ]] ; then
    graph="[$graph]"
  fi
  if [[ ("$username" != "") ]] ; then
    username="$username:$password@"
  fi
  graph_adress="$username$endpoint_adress$graph"
fi

public=$(cat $DIR/checkpubliclist.txt)
if [[ ($(echo $endpoint_adress | grep -xE $public -) != "") ]] ; then
  echo "please, do not run RDF2Graph directly on a public endpoint" 1>&2;
  exit
fi

java -jar $DIR/programs/RDF2Graph/target/RDF2Graph-0.1-jar-with-dependencies.jar temp $graph_adress --all $removeOWL $simplify
tdbquery --loc temp --query $DIR/programs/RDF2Graph/rdfExporter/queries/all.txt --results N3 > $output
$DIR/programs/RDF2Graph/rdfExporter temp $output

