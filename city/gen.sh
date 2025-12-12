# 指定需要生成的 proto 目录列表
PROTO_NAMES=(
    "mpaaspush"
)

BASE_MODULE="github.com/openimsdk/protocol/city/proto"

# 生成基础 pb.go（Message、序列化等）
echo "===== Generating Go PB files ====="
for name in "${PROTO_NAMES[@]}"; do
    proto_file="./city/proto/${name}.proto"

    if [ ! -f "${proto_file}" ]; then
        echo "ERROR: proto file not found: ${proto_file}"
        exit 1
    fi

    protoc --go_out=./city/proto \
           --go_opt=module=${BASE_MODULE} \
           ${proto_file}

    if [ $? -ne 0 ]; then
        echo "error processing ${name}.proto (go_out)"
        exit 1
    else
        echo "Generated: ${name}.pb.go"
    fi
done


# 生成 Triple RPC Stub
echo "===== Generating Dubbo Triple files ====="
for name in "${PROTO_NAMES[@]}"; do
    proto_file="./city/proto/${name}.proto"

    protoc --go-triple_out=./city/proto \
           --go-triple_opt=module=${BASE_MODULE} \
           ${proto_file}

    if [ $? -ne 0 ]; then
        echo "error processing ${name}.proto (go-triple_out)"
        exit 1
    else
        echo "Generated: ${name}.triple.pb.go"
    fi
done


# 修复 pb.go 中可能的 tag 生成异常
echo "===== Fixing generated tags ====="
if [ "$(uname -s)" == "Darwin" ]; then
    find . -type f -name '*.pb.go' -exec sed -i '' 's/,omitempty"`/\"\`/g' {} +
else
    find . -type f -name '*.pb.go' -exec sed -i 's/,omitempty"`/\"\`/g' {} +
fi

echo "===== All Done ====="
