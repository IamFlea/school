"""
Cartesian Genetic Programming
=============================
Genetic Programming is concerned with the automatic  evolution  (as  in 
Darwinian evolution) of computational structures (such as  mathematical 
equations, computer programs, digital circuits, etc.). CGP is a  highly 
efficient and flexible form of Genetic Programming that encodes a graph 
representation of a computer program. It was developed by Julian Miller
in 1999. For more information see: http://cartesiangp.co.uk/

This script written by Petr Dvoracek in 2017.         http://flea.name/
"""

import random 
from copy import deepcopy

# The main pillar of this algorithm lies in the directed oriented graph in
# which each node represents a specific operation. 
# The nodes are commonly arranged in square lattice.
DEFAULT_MATRIX_SIZE = (2, 5) # ROWS, COLS

# The interconnection between columns. 
DEFAULT_LEVEL_BACK = 5 # If the value is equal to number of columns then 
                       # the interconnection is maximal.

# The operation set. 
# List of tuples(`str` name, `int` arity (inputs), `function` operation). 
DEFAULT_OPERATION_SET = set([("BUF",  1, lambda *arg: arg[0]), # Note maximal arity is two, thus it has two parameters. 
                             ("NOT",  1, lambda *arg: ~arg[0]), 
                             ("AND",  2, lambda *arg: ~(arg[0] & arg[1])), 
                             ("OR",   2, lambda *arg: ~(arg[0] | arg[1])), 
                             ("XOR",  2, lambda *arg: arg[0] & arg[1]), 
                             ("NAND", 2, lambda *arg: arg[0] | arg[1]),
                             ("NOR",  2, lambda *arg: arg[0] ^ arg[1]), 
                             ("XNOR", 2, lambda *arg: ~(arg[0] ^ arg[1])),
                            ])

# Lets find full adder by default.
# For all input combinations define:
DEFAULT_INPUT_DATA =    [0b00001111, # A
                         0b00110011, # B
                         0b01010101] # Carry in
# Define output combinations
DEFAULT_TRAINING_DATA = [0b01101001, # SUM
                         0b00010111] # Carry out

# The CGP is a genetic algorithm. Therefore, we need to define evolutionary parameters.
# The number of candidate solutions.
DEFAULT_POP_SIZE = 5  
# Maximal generations (how long the algorithm will run)
DEFAULT_MAX_GENERATIONS = 10000 

# This function returns the list of objects with poistion `index` in the `nested_list` (list of arrays).
# Example:  get_sublist(1, [("A", 3, 5), ("C", 1), ("D", "C")]) --> [3, 1, "C"]
get_sublist = lambda index, nested_list : list(map(lambda sublist: sublist[index], nested_list))

# How many genes will be mutated.
# 10% of the chromosome length can be mutated. Chromosome length = each_node * len(node) + len(last_node); The length of node is maximal arity + the operation.
DEFAULT_MUTATIONS = int((DEFAULT_MATRIX_SIZE[0] * DEFAULT_MATRIX_SIZE[1] * (max(get_sublist(1, DEFAULT_OPERATION_SET)) + 1) + len(DEFAULT_TRAINING_DATA)) * 0.10)
#DEFAULT_MUTATIONS = 4



class CGP(object):
    # Printing if we find better fitness during the evolution.
    PRINT_INFO = False

    def __set_connections(self):
        """ Calculates the set of valid connections """
        # For each column create valid connection interval from previous `l-back` connections.
        self._valid_connection = [(self.rows * (column - self.level_back), self.rows * column) for column in range(self.columns)] 
        # Filter invalid indexes which are negative -> make them 0
        self._valid_connection = list(map(lambda sublist: list(map(lambda x: x if (x >= 0) else 0, sublist)), self._valid_connection))

    def __test_operation_set(self, operation_set):
        """ Check the validity of operation set.
    
        Parameters
            operation_set : list of operations
                Each opeartaion is a tuple(`str` name, `int` arity, `function` operation). 
        Raises
            CGPError
                If the operation set contains inconsistent operations.
        """
    
        # Test for empty set.
        if not operation_set:
            raise CGPError("EMPTY_SET")
        # Test if each operation has a triplet of (str, int, function) and tests the arity.
        for operation in operation_set:
            if len(operation) != 3 or type(operation[0]) is not str \
                                   or type(operation[1]) is not int \
                                   or not callable(operation[2]):
                raise CGPError("INCONSISTENT_SET", value=operation)
            # Negative arity of function is stupid. Unless, you are doing some deep shit math. 
            if operation[1] < 0: 
                raise CGPError("INCONSISTENT_ARITY", value=operation)

    def set_data(self, input_data, training_data):
        """ Set Input and output data
        
        Parameters
            input_data : list
                The list of input data. In the case of digital circuit design, 
                this contains all the input combinations. 
            training_data : list
                The target circuit.
        """
        self.input_data_range = list(range(-len(input_data), 0))
        self.input_data = input_data
        self.training_data = training_data

    def set_matrix(self, matrix, level_back=0):
        """ Initate the matrix. 

        Parameters
            matrix : tuple (int, int)
                This tuple represents the size of matrix (rows, columns)

        Other Parameters
            level_back : int
                The interconnection between columns.
        """
        self.matrix = matrix # Though, it is not used.
        self.rows = matrix[0]
        self.columns = matrix[1]

        self.level_back = level_back if level_back > 0 else matrix[1] # If `level_back` has invalid value (0 or less), then the interconnection is maximal. 
        self.__set_connections()
    
    def set_operation_set(self, operation_set):
        """ Set the operation set.
        Parameters
            operation_set : list of operations
                Each opeartaion is a tuple(`str` name, `int` arity, `function` operation). 
        Raises
            CGPError
                If the operation set contains inconsistent operations.
        """
        self.__test_operation_set(operation_set)
        self.operation_set = operation_set
        # Transpose the operation set data.
        self.operations = get_sublist(2, operation_set)
        self.operations_arity = get_sublist(1, operation_set)
        self.operations_names = get_sublist(0, operation_set)
        # Get maximal arity
        self.maximal_arity = max(self.operations_arity)
    
    def __init__(self, matrix, operation_set, input_data, training_data, level_back=0):
        """ Initate the matrix, node arrangement, operation set and i/o data. 

        Parameters
            matrix : tuple (int, int)
                This tuple represents the size of matrix (rows, columns)
            operation set : list of tuples (`str` name, `int` arity, `function` operation). 
                The operation set.
            input_data : list
                The list of input data. In the case of digital circuit design, 
                this contains all the input combinations. 
            training_data : list
                The target circuit.

        Other Parameters
            level_back : int
                The interconnection between columns.

        Raises
            CGPError
                If the operation set contains inconsistent operations.
        """
        super(CGP, self).__init__()
        
        self.set_matrix(matrix, level_back=level_back)
        self.set_operation_set(operation_set)
        self.set_data(input_data, training_data)

    def __create_chromosome(self):
        """ Initate the chromosome. 
        The chromsome encodes the interconnection of the CGP graph. See: http://www.oranchak.com/cgp/doc/fig2.jpg
        """
        # Init array for chromosome
        chromosome = []
        # This function selects random value from input data or previous node in the graph.
        connect = lambda connection: random.choice(self.input_data_range + list(range(connection[0], connection[1])))
        
        # Nodes may differ by their connection between columns. The interconnection is depended on the value of level back. 
        for column_index in range(self.columns):
            # Get valid connection range for nodes in the column
            valid_con = self._valid_connection[column_index]
            # Function for the creation of the node. Firstly creates the connections, then adds the node operation. 
            create_node = lambda: [connect(valid_con) for _ in range(self.maximal_arity)] + [random.choice(self.operations)]
            chromosome += [create_node() for _ in range(self.rows)]
        # Add last `node` which binds the primary outputs of the graph to nodes.
        valid_con = (0, len(chromosome))
        chromosome += [[connect(valid_con) for _ in self.training_data]]
        return chromosome

    def __init_pop(self, pop_size):
        """ Initiate the population of `pop_size` size """
        self.pop = [self.__create_chromosome() for _ in range(pop_size)]
        # The best individual is saved in `self.best_chrom` with the best fitness `self.fitness`.
        self.best_chrom = deepcopy(self.pop[0])
        self.best_fitness = self.max_fitness

    def __mutate_gene(self, chromosome):
        """ Mutate random value in a `chromsome`. 
        
        Parameters
            chromosome : chromsome strucutre
                The representation of candidate solution which is subject to a mutation. 
        """
        # This function selects random value from input data or previous node in the graph.
        connect = lambda connection: random.choice(self.input_data_range + list(range(connection[0], connection[1])))
        # Select some node
        random_node_idx = random.randint(0, len(chromosome) - 1)
        random_node = chromosome[random_node_idx]
        
        # And select an index from the node
        random_idx = random.randint(0, len(random_node) - 1) # Note: A <= rnd <= B
        previous_value = random_node[random_idx]
        if random_node is chromosome[-1]:
            # We mutate the last node
            while previous_value == random_node[random_idx]:
                random_node[random_idx] = connect((0, len(chromosome)))
        elif random_idx == self.maximal_arity:
            # We mutate the operation (indexing from 0)
            while previous_value == random_node[random_idx]:
                random_node[random_idx] = random.choice(self.operations)
        else:
            # We mutate the connection
            while previous_value == random_node[random_idx]:
                random_node[random_idx] = connect(self._valid_connection[ random_node_idx // self.rows ])

    def mutate(self):
        """ Creates a copy of the best solution and mutates it random-times.

        Return
            chromsome : chromosome structure
                The representation of the other candidate solution, which is similar to the best found solution.
        """
        # Copy the best chromsome
        chromosome = deepcopy(self.best_chrom)
        # And mutate it as much as possible
        for _ in range(random.randint(1, self.mutation_rate+1)): # Mutate it at least once. Else the chromsome wouldn't change.
            self.__mutate_gene(chromosome)
        return chromosome

    def init_eval(self):
        """ This function is started before the run of evolution. """
        # Buffer for the evaluation.
        buffer_data = deepcopy(self.input_data) + list(range(self.rows * self.columns + len(self.training_data)))
        buffer_indexes = list(range(-len(self.input_data), len(buffer_data) - len(self.input_data)))
        self.buffer = dict(zip(buffer_indexes, buffer_data))
        
        # Maximal fitness
        self.max_fitness = len(self.training_data) * (2 ** len(self.input_data))

        # Fitness mask.
        #              V mask V  The number of bites V        # We are doing parallel evaluation. 
        self.bitmask = 2 ** (2 ** len(self.input_data)) - 1
        # Set generations.
        self.generation = 0

    def chrom_to_str(self, chromosome):
        """ Creates a string representation of chromosome, in which the nodes are aligned into a lattice. 
        Each node has syntax   `index` : [`previous index`, ... , `previous index`, `Function name`]   
        If the node was primary output, then the node is ended with a string `<- `. 
        The primary outputs are also printed in the last line for the sake of their permutation. 

        Parameters
            chromsome : chromosome structure
                The representation of chromosome.
        Returns
            str
                The string representation of chromosome.
        """
        # Some math stuff
        max_input_strlen = len(str(self.columns * self.rows))
        max_length_of_operation_string = max(list(map(len, self.operations_names)))
        chrom_str = ""
        for i in range(self.rows):
            line = ""
            for j in range(self.columns):
                # Grab the node index 
                node_idx = j * self.rows + i
                node = chromosome[node_idx]
                # Find the inputs, and align them.
                inputs = node[:-1] # The last node is operation; the rest are the inputs.
                aligned_inputs = list(map(lambda x: str(x).rjust(max_input_strlen), inputs))
                # Find out the operation name and align it.
                operation = node[-1]
                operation_index = self.operations.index(operation)
                operation_name = self.operations_names[operation_index]
                aligned_operation_name = operation_name.rjust(max_length_of_operation_string)
                # save it
                if node_idx in chromosome[-1]:
                    flag = "<- "
                else:
                    flag = "   "
                line +=  str(node_idx).rjust(max_input_strlen) + ": [" + ", ".join(aligned_inputs) + ", " + aligned_operation_name + "]" + flag
            chrom_str += line + "\n"
        return chrom_str + str(chromosome[-1])

    
    def eval(self, chromosome):
        """ Evaluates the `chromosome` and returns the fitness value. Also checks if we found a better solution.
        Parameters
            chromsome : chromosome structure
                The representation of a candidate solution.
        Returns
            int : fitness value
                The quality of the candidate solution.
        TODO
            Optimise it. Skip neutral mutations. Skip unused nodes. (Maybe use C/C++ function?)
            Move the fitness check 
        """
        fitness = 0 
        # Evaluate each node.
        for idx, node in enumerate(chromosome[:-1]):
            # TODO SKIP unused nodes
            # Save the value of the operation `node[-1]`. The arguments are given in `node[:-1]` and they are the indexes into the `buffer`.
            self.buffer[idx] = node[-1](*[self.buffer[i] for i in node[:-1]])
        # Grab the value 
        for idx, target in zip(chromosome[-1], self.training_data):
            #print idx, target, self.bitmask
            fitness += bin((self.buffer[idx] ^ target) & self.bitmask).count("1")
        # Checks if we found a better solution.
        # Shouldnt be here.
        if fitness <= self.best_fitness:
            if CGP.PRINT_INFO and fitness < self.best_fitness:
                print("Generation: " + str(self.generation).rjust(10) + "\tFitness: " + str(fitness))
            self.best_fitness = fitness
            self.best_chrom = deepcopy(chromosome)
        return fitness

    def run(self, pop_size, mutations, generations):
        """  Runs the evolution.
        Parameters
            chromsome : chromosome structure
                The representation of chromosome.
        """
        # Init evaluation
        self.init_eval()
        # Init mutation
        self.mutation_rate = mutations
        # Creates first population `self.pop` and evaluates it `self.eval`.
        self.__init_pop(pop_size)
        # Run evolution
        for self.generation in range(generations):
            # Evaluate pop
            list(map(self.eval, self.pop))
            # Mutate pop; fix the peroformance 
            new_pop = [self.mutate() for _ in self.pop]
            self.pop = new_pop
            #break
        
    def __str__(self):
        return self.chrom_to_str(self.best_chrom)
        

class CGPError(Exception):
    def __init__(self, error_code, value=""):
        """ Inits the exception. """
        self.error_code = error_code
        self.value = value

    def __str__(self):
        """ Print error message, depending on the given error code. """
        error_msg = {
            "EMPTY_SET" : "The operation set is empty.",
            "INCONSISTENT_SET" : "The operation set contains inconsistent operation: " + repr(self.value) + "\n"\
                               + "Please use triplet (`str` name, `int` arity, `function` operation)",
            "INCONSISTENT_ARITY" : "The arity of operation " + repr(self.value) +" can not be negative.", # Note: if you are doing some high math sh.t, then write your own CGP with blackjack and h..kers.
        }.get(self.error_code, "Unknown error - " + repr(self.error_code))
        return error_msg


if __name__ == '__main__':
    CGP.PRINT_INFO = True
    cgp = CGP(DEFAULT_MATRIX_SIZE, DEFAULT_OPERATION_SET, DEFAULT_INPUT_DATA, DEFAULT_TRAINING_DATA)
    cgp.run(DEFAULT_POP_SIZE, DEFAULT_MUTATIONS, DEFAULT_MAX_GENERATIONS)
    print(cgp)