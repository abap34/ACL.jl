using Test
using ACL

function readfile(file)
    str = open(file, "r") do fp
        readlines(fp)
    end
    str
end

checker_path = "../../library-checker-problems/"    # library_checker_problemsが存在するpath
gen_path = checker_path * "generate.py"             # generate.pyの場所

# library-checker-problems内での各検証用問題のディレクトリ
library_checker_problem_dict = Dict([
    "dsu" => "datastructure/unionfind"
    "scc" => "graph/scc"
    "floorsum" => "math/sum_of_floor_of_linear"
])

tests = ["floorsum"]

@testset "ACL" begin

for testname in tests
    @testset "$testname" begin


        problem_path = library_checker_problem_dict[testname]   # 問題に対応するlibrary checker problems内のディレクトリ
        problem = split(problem_path, "/")
        problem = problem[length(problem)]                      # 問題名

        input_path = checker_path * problem_path * "/in/"       # inputファイルの場所
        output_path = checker_path * problem_path * "/out/"     # outputファイルの場所

        run(`python3 $gen_path -p $problem`)                    # inputファイルとoutputファイルを生成
        # ここのpython3は適宜自分の環境に合わせて変更する
        
        in_list = readdir(input_path)                           # inputファイルのリスト

        for input_file in in_list
            case = input_file[1:length(input_file)-3]
            output_file = case * ".out"                                 # outputファイルの名前
            answer = join(readfile(output_path * output_file), "/n")    # 答えをロード
        
            input = [readfile(input_path * input_file), 1]              # inputデータ
            
            myoutput = []                                               # testファイルが出したoutputを格納する

            include("$testname.jl")                                     # testファイルのinclude
            
            main(input, myoutput)                                       # testファイル内で定義されているmain関数

            myoutput = join(myoutput, "/n")

            @test myoutput == answer
        end
        
    end
end

end

#=
# AtCoderのjudgeシステムを再現しようとしたもの
# こちらの方が実機での実行時間を反映するはず？
# ただ、このコード単体では動くが、入出力ストリームを弄るところがテストシステムに適合できず、組み入れるのを中止

target = "unionfind"
target_path = "datastructure/unionfind"
checker_path = "../../library-checker-problems/"
gen_path = checker_path * "generate.py"
input_path = checker_path * target_path * "/in/"
output_path = checker_path * target_path * "/out/"


function readfile(file)
    str = open(file, "r") do fp
        readlines(fp)
    end
    join(str, "\n") * "\n"
end

run(`python3 $gen_path -p $target`)
in_list =  readdir(input_path)

b = IOBuffer()

@async while true
    write(b, redirect_stderr()[1])
end

sleep(1)

for input_file in in_list
    problem = input_file[1:length(input_file)-3]
    output_file = problem * ".out"
    myoutput_file = problem * ".my"
    output_stream = open(myoutput_file, "w")
    proc = open(`time -p julia Main.jl`, output_stream, write=true)
    input = readfile(input_path * input_file)
    write(proc.in, input)
    close(proc.in)
    read(proc.out, String)
    sleep(1)
    t = split(String(take!(b)))[2]
    output = readfile(myoutput_file)
    answer = readfile(output_path * output_file)
    run(`rm $myoutput_file`)
    if output == answer
        println(problem * " AC " * t)
    else
        println(problem * " WA " * t)
    end  
end

=#