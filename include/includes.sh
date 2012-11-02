include_files=( "log.sh" "common_config.sh" "common_functions.sh" ) 

default_path="../include"

for include_file in ${include_files[@]}
do
  if [ -f "${default_path}/${include_file}" ]; then
    includes+=( "${default_path}/${include_file}" )
  else
    echo "File ${include_file} not found."
  fi
done

for include in ${includes[@]}
do
  if [ -f ${include} ]; then
    . ${include}
  else
    echo "File ${include} not found."
  fi
done
