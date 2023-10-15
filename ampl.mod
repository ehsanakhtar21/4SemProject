# Decision Variables
var x{i in FUND, j in EXPENSE} >= 0, <= ub_values[i,j];

# Objective Function
maximize TotalWeightedAllocation: sum{i in FUND, j in EXPENSE} weight_vector[i] * x[i,j];

# Constraints

# General and Earmarking Constraints
s.t. ZeroConstraints{i in FUND, j in EXPENSE: not_allowed[i,j] = 1}: x[i,j] = 0;

# Earmarking Constraints

# Unearmarked Funds
s.t. Unearmarked_Constraints {i in FUND, j in EXPENSE: fund_earmarking_level[i] = "Unearmarked"}:
    x[i,j] <= fund_amount[i];

# Tightly Earmarked Funds
s.t. TightlyEarmarked_Operation {i in FUND, j in EXPENSE: fund_earmarking_level[i] = "Tightly Earmarked" && fund_operation[i] != expense_operation[j]}:
    x[i,j] = 0;
s.t. TightlyEarmarked_Country {i in FUND, j in EXPENSE: fund_earmarking_level[i] = "Tightly Earmarked" && fund_country[i] != expense_country[j]}:
    x[i,j] = 0;
# ... Add similar constraints for other fields in Tightly Earmarked

# Earmarked Funds
s.t. Earmarked_Operation {i in FUND, j in EXPENSE: fund_earmarking_level[i] = "Earmarked" && fund_earmarking_type[i] = "Operation" && fund_country[i] != expense_country[j]}:
    x[i,j] = 0;

# Softly Earmarked Funds
# ... Add constraints for each earmarking type, similar to Tightly Earmarked, based on the conditions_map in Python



# Fund Utilization Constraint
s.t. FundUtilization{i in FUND}: sum{j in EXPENSE} x[i,j] <= fund_amount[i];

# Expense Utilization Constraint
s.t. ExpenseUtilization{j in EXPENSE}: sum{i in FUND} x[i,j] <= expense_amount[j];

# Solve command (to be run in AMPL after loading the data)
# solve;

