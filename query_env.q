{[other_namespaces;excluded_namespaces]
 / global namespace is represented by empty symbol `
 namespaces:$[other_namespaces; `, key `; enlist `] except excluded_namespaces union `q`Q`h`j`o;

 get_func_var_from_namespace:{[namespace]
  / function that returns all variables and functions of namespace
  snamespace:$[namespace=`; ""; ".", string namespace];
  :(system "v ", snamespace), (system "f ", snamespace)
  };

 get_doc:{[namespace; variable]
  / creates a dictionary of documentation about VARIABLE in NAMESPACE
  / get variable/function using eval
  x: eval $[namespace=`; variable; `$".", (string namespace), ".", string variable];
  t: type x;
  / helper function to get string body
  max_body: 100; / maximum length
  truncate_string:{[max_body;s] $[max_body < count s; (max_body# s), "..."; s]}[max_body];

  / output documentation dictionary
  :$[
   / is a table, give cols
   .Q.qt x; `type`cols! t, enlist cols x;
   / is a dictionary give keys
   t = 99 ; `type`keys! t, enlist key x;
   / is a lambda, give parameters, file and body excerpt
   t = 100; {[t;x;f] v:value x;
    result: `type`param`body! t,(enlist v[1]), enlist f (reverse v)[0];
    if[0 < count (reverse v)[2]; result[`file]: (reverse v)[2]];
    :result }[t;x;truncate_string];
   / projection, composition, iteration
   t within (104;111); `type`body! t, enlist truncate_string .Q.s x;
   / other only give type
   (enlist `type)!enlist t
   ]
  };

 / compose the above two functions together
 generate:{[f;g;namespace]
  vars:f[namespace];
  :vars! g[namespace] each vars
  } [get_func_var_from_namespace; get_doc];

 / putting it all together
 :.j.j namespaces! generate each namespaces
 }
