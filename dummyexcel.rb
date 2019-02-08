$grid = {}
$alphabets = ('A'..'J')
$numbers = (0..9)
$dependents = {}
$expressions = {}

def printGrid
    print("*".ljust(6))
    for i in $alphabets
        print(i.ljust(6))
    end 
    print("\n")
    for i in $numbers
        print("#{i}".ljust(6))
        for j in $alphabets
            print("#{$grid[i][j]}".ljust(6))
        end
        print("\n")
    end
end

def createGrid
    for i in $numbers
        $grid[i]={}
        for j in $alphabets
            $grid[i][j]='-'
        end
    end    
end

def setValue(valueExp)
    splitExp = valueExp.split(" ")
    col = splitExp[0][0]
    row = splitExp[0][1..-1].to_i
    $grid[row][col] =splitExp[2]
    #puts($grid[row][col])
end

def evaluate(expression)
    exparr = expression.split(' ')
    #puts "exparr #{exparr}"
    dcol = exparr[0][0]
    drow = exparr[0][1..-1].to_i 
    operator = exparr[3]
    col1 = exparr[2][0]
    row1 = exparr[2][1..-1].to_i
    col2 = exparr[4][0]
    row2 = exparr[4][1..-1].to_i
    case operator
    when '+'
        answer = $grid[row1][col1].to_f+$grid[row2][col2].to_f
    when '-'
        answer = $grid[row1][col1].to_f-$grid[row2][col2].to_f
    when '*'
        answer = $grid[row1][col1].to_f*$grid[row2][col2].to_f
    when '/'
        answer = $grid[row1][col1].to_f/$grid[row2][col2].to_f
    when '**'
        answer = $grid[row1][col1].to_f**$grid[row2][col2].to_f
    else
        puts("Invalid operators")
    end
    #puts(drow,dcol)
    $grid[drow][dcol] = answer
end

def changeDependets(exp)
    exparr = exp.split(' ')
    cell= exparr[0]
    temparr = [] 
    if ($dependents[cell] != nil)
        temparr = $dependents[cell]
        len = temparr.length
        i=0
        while(i!=len)
            if($dependents[temparr[i]]!= nil)
                temparr.concat($dependents[temparr[i]])
                len = len+$dependents[temparr[i]].length
            end
            i=i+1
        end
        temparr.uniq!
        temparr.each  do |i|
            evaluate($expressions[i])
        end
    end
end


def addToDependents(expr)
    exp =expr.split(' ') 
    p exp
    destinationcell = exp[0]
    cell1 = exp[2]
    operator = exp[3]
    cell2 = exp[4]
    $expressions[destinationcell] = expr
    if($dependents[cell1] == nil)
        $dependents[cell1]=[]
        $dependents[cell1] = $dependents[cell1].push(destinationcell)
    else
        $dependents[cell1] = $dependents[cell1].push(destinationcell)
    end
    if($dependents[cell2] == nil)
        $dependents[cell2]=[]
        $dependents[cell2] = $dependents[cell2].push(destinationcell)
    else
        $dependents[cell2] = $dependents[cell2].push(destinationcell)
    end      
end

createGrid
while true
    puts("1) Set Value")
    puts("2) Set Expression")
    puts("3) Exit")
    $userInput = gets
    $userInput = $userInput.chomp.to_i
    case $userInput
    when 1
        valueExp = gets
        setValue(valueExp.chomp)
        changeDependets(valueExp.chomp)
        printGrid
    when 2
        expression = gets
        addToDependents(expression.chomp)
        evaluate(expression)
        printGrid
    end
    #puts $dependents
    #puts $expressions 
end

