# 指定需要生成的 proto 目录列表
PROTO_NAMES=(
    "mpaas"
)


for name in "${PROTO_NAMES[@]}"; do
 protoc --go_out=./${name} --go_opt=module=github.com/openimsdk/protocol/city/${name} ${name}/${name}.proto
  if [ $? -ne 0 ]; then
      echo "error processing ${name}.proto (go_out)"
      exit $?
  fi
done


for name in "${PROTO_NAMES[@]}"; do
 protoc --go-triple_out=./${name} --go-triple_out=module=github.com/openimsdk/protocol/city/${name} ${name}/${name}.proto
  if [ $? -ne 0 ]; then
      echo "error processing ${name}.proto (go-triple_out)"
      exit $?
  fi
done

if [ "$(uname -s)" == "Darwin" ]; then
    find . -type f -name '*.pb.go' -exec sed -i '' 's/,omitempty"`/\"\`/g' {} +
else
    find . -type f -name '*.pb.go' -exec sed -i 's/,omitempty"`/\"\`/g' {} +
fi
