from zopy.doitutils import dodict

alias = {
    "MYSCRIPT":"/n/h/isdjhfjsdjfisjdofij",
}
    
def task_find_headers( ):
    return dodict( ["grep '^>' d:{MYSCRIPT} d:file1.faa d:file2.faa",
                    "> t:headers.txt"], alias=alias )

def task_count_headers( ):
    return dodict( "wc -l d:headers.txt > t:count.txt" )
