# JuMP_report

This is a small package to generate reports for MCP JuMP models. 


The only exported function is 

    report(m::JuMP.Model)

This returns a DataFrame with four columns, `:var`, 
`:base_name`, `:value`, and `:margin`. 

# Example 

```julia
using JuMP

using JuMP_report
using PATHSolver

using DataFrames

I = Symbol.(:i,1:10)

m = Model(PATHSolver.Optimizer)

@variables(m, begin
    x[I]
    y
    z
end)

@constraints(m, begin
    eqn_x[i=I], x[i]^2+2*x[i]-1 ⟂ x[i]
    eqn_y, y^2+2*y-1 ⟂ y
    eqn_z, z^2+2*z-1 ⟂ z
end)

optimize!(m)

df = report(m)
```
The `:base_name` column can be used to extract specific variables using DataFrame methods. Here is an example of extracting the `x`
variable and sorting by margin, largest to smallest.
```julia
df |>
    x -> subset(x, 
        :base_name => ByRow(==("x"))
    ) |>
    x -> sort(x, :margin, rev=true)
```