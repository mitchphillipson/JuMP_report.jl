module JuMP_report

    using DataFrames
    using JuMP

    export report;

    extract_variable_ref(v::NonlinearExpr) = v.args[1]
    extract_variable_ref(v::AffExpr) = collect(keys(v.terms))[1]
    extract_variable_ref(v::QuadExpr) = extract_variable_ref(v.aff)

    function base_name(x::VariableRef)
        n = name(x)
        split_n = split(n,"[")
        return String(split_n[1])
    end


    function report(m::JuMP.Model)
        
        out = []

        #mapping = Dict()
        for ci in all_constraints(m; include_variable_in_set_constraints = false)
            c = constraint_object(ci)

            var = extract_variable_ref(c.func[2])
            val = value(var)
            margin = value(c.func[1])

            base = base_name(var)

            push!(out,(var,base, val,margin))
            #mapping[extract_variable_ref(c.func[2])] = c.func[1]
        end

        df = DataFrame(out,[:var,:base_name,:value,:margin])
        return df

    end;

end # module JuMP_report
