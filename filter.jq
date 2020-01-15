[
  [                                               
    split("\n")[]                  # transform csv input into array
  | split(",")                    # where first element has key names
  | select(length==6)              # and other elements have values
  ]                                
  | {h:.[0], v:.[1:][]}            # {h:[keys], v:[values]}
  | [.h, (.v|map(tonumber?//.))]   # [ [keys], [values] ]
  | [ transpose[]                  # [ [key,value], [key,value], ... ]
      | {key:.[0], value:.[1]}     # [ {"key":key, "value":value}, ... ]
    ]
  | from_entries                   # { key:value, key:value, ... }
]
