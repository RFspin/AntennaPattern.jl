
"""
# Standard CST 3D ASCII file header
"""
macro STANDARD_CST_3D_PATTERN_COLUMNS()
    return quote
        ["θ[deg.]", "φ[deg.]", "|Dir.|[dBi]", "|θ|[dBi]", "∠θ[deg.]", "|φ|[dBi]", "∠φ[deg.]", "AR[dB]"]
    end 
end


"""
# Preprocessing of CST 3D ASCII file
Generates a CSV file from a CST 3D ASCII file. The CST 3D ASCII file is a text file with the following format:

    - ["Theta[deg.]", "Phi[deg.]", "|Dir.|[dBi]", "|Theta|[dBi]", "∠Theta[deg.]", "|Phi|[dBi]", "∠Phi[deg.]", "AR[dB]"]
## Inputs: 
    - input_filename: path to the input file
    - output_filename: path to the output file
## Outputs:
    - output_filename: processed file

"""
function preprocess_CST_3D_ASCII_file(input_filename, output_filename)
    open(input_filename, "r") do infile
        open(output_filename, "w") do outfile
            for line in eachline(infile)
                # Replace sequences of spaces with a single comma
                processed_line = replace(line, r"\s+" => ",")
                
                # Remove the first comma if it exists
                if startswith(processed_line, ",")
                    processed_line = processed_line[2:end]
                end

                # Remove the last comma if it exists
                if endswith(processed_line, ",")
                    processed_line = processed_line[1:end-1]
                end

                # Write the processed line to the output file
                println(outfile, processed_line)
            end
        end
    end
end
