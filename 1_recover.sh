
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

java -jar $DIR/programs/RDF2Graph/target/RDF2Graph-0.1-jar-with-dependencies.jar temp file://$input{$extension} --all --useClassPredFindAtOnce --executeSimplify
tdbquery --loc temp --query $DIR/programs/RDF2Graph/rdfExporter/queries/all.txt --results N3 > $output
#$DIR/programs/RDF2Graph/rdfExporter temp $output

