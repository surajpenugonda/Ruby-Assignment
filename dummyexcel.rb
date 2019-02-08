
def print_grid(grid)
    alphabets = ('A'..'J')
    numbers = (0..9)
    print("*".ljust(6))
    alphabets.each do |i|
        print(i.ljust(6))
    end 
    print("\n")
    numbers.each do |i|
        print("#{i}".ljust(6))
        alphabets.each do |j|
            print("#{grid[i][j]}".ljust(6))
        end 
        print("\n")
    end
end

def create_grid(grid)
    alphabets = ('A'..'J')
    numbers = (0..9)
    numbers.each do |i|
        grid[i]={}
        alphabets.each do |j|
            grid[i][j]='-'
        end 
    end
    return grid
end

def set_value(valueExp,grid)
    splitExp = valueExp.split(" ")
    col = splitExp[0][0]
    row = splitExp[0][1..-1].to_i
    grid[row][col] =splitExp[2]
    #puts($grid[row][col])
    return grid
end

def evaluate(expression,grid)
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
        answer = grid[row1][col1].to_f+grid[row2][col2].to_f
    when '-'
        answer = grid[row1][col1].to_f-grid[row2][col2].to_f
    when '*'
        answer = grid[row1][col1].to_f*grid[row2][col2].to_f
    when '/'
        answer = grid[row1][col1].to_f/grid[row2][col2].to_f
    when '**'
        answer = grid[row1][col1].to_f**grid[row2][col2].to_f
    else
        puts("Invalid operators")
    end
    #puts(drow,dcol)
    grid[drow][dcol] = answer
    return grid
end

def change_dependets(exp,grid,dependents,expressions)
    exparr = exp.split(' ')
    cell= exparr[0]
    temparr = [] 
    if (dependents[cell] != nil)
        temparr = dependents[cell]
        len = temparr.length
        i=0
        while(i!=len)
            if(dependents[temparr[i]]!= nil)
                temparr.concat(dependents[temparr[i]])
                len = len+dependents[temparr[i]].length
            end
            i=i+1
        end
        temparr.uniq!
        temparr.each  do |i|
            grid = evaluate(expressions[i],grid)
        end
    end
    return grid
end


def add_to_dependents(expr,dependents,expressions)
    exp =expr.split(' ') 
    p exp
    destinationcell = exp[0]
    cell1 = exp[2]
    operator = exp[3]
    cell2 = exp[4]
    expressions[destinationcell] = expr
    if(dependents[cell1] == nil)
        dependents[cell1]=[]
        dependents[cell1] = dependents[cell1].push(destinationcell)
    else
        dependents[cell1] = dependents[cell1].push(destinationcell)
    end
    if(dependents[cell2] == nil)
        dependents[cell2]=[]
        dependents[cell2] = dependents[cell2].push(destinationcell)
    else
        dependents[cell2] = dependents[cell2].push(destinationcell)
    end  
    return [dependents,expressions]    
end



grid = {}
dependents = {}
expressions={}
grid = create_grid(grid)
while true
    puts("1) Set Value")
    puts("2) Set Expression")
    puts("3) Exit")
    userInput = gets
    userInput = userInput.chomp.to_i
    case userInput
    when 1
        valueExp = gets
        grid = set_value(valueExp.chomp,grid)
        change_dependets(valueExp.chomp,grid,dependents,expressions)
        print_grid(grid)
    when 2
        expression = gets
        temp = add_to_dependents(expression.chomp,dependents,expressions)
        dependents = temp[0]
        expressions = temp[1]
        grid = evaluate(expression,grid)
        print_grid(grid)
    when 3
        exit!
    end
    #puts $dependents
    #puts $expressions 
end

