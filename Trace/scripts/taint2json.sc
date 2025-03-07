@main def exec(bin: String, file: String){
  importCpg(bin)
  try{
    val src = cpg.identifier
    //println(s"Source Identifiers: \n${src.toJsonPretty}")
    val sink = cpg.call
    //println(s"-----------------------------------------------")
    //println(s"-----------------------------------------------")
    //println(s"-----------------------------------------------")
    //println(s"-----------------------------------------------")
    //println(s"Sink Calls: \n${sink.toJsonPretty}")
	
    //val flowResult = sink.reachableByFlows(src).toJsonPretty
    //println(s"Taint Flows: \n$flowResult")
    //flowResult |> s"${file}"
    sink.reachableByFlows(src).toJsonPretty |> s"${file}" 
  }catch{
    case e: Exception => println("Couldn't parse that file.")
  }

}
