#' List BigQuery tables in a dataset
#' 
#' @param projectId The BigQuery project ID
#' @param datasetId A datasetId within projectId
#' 
#' Example: bqr_list_tables("publicdata", "samples")
#' 
#' @export
bqr_list_tables <- function(projectId, datasetId){
  
  l <- googleAuthR::gar_api_generator("https://www.googleapis.com/bigquery/v2",
                                      "GET",
                                      path_args = list(projects = projectId,
                                                       datasets = datasetId,
                                                       tables = ""),
                                      data_parse_function = function(x) {
                                        d <- x$tables
                                        out <- data.frame(id = d$id,
                                                          projectId = d$tableReference$projectId,
                                                          datasetId = d$tableReference$datasetId,
                                                          tableId = d$tableReference$tableId)
                                        
                                      })
  l(path_arguments = list(projects = projectId, 
                          datasets = datasetId))
  
}

#' Get BigQuery Table meta data
#' 
#' @param projectId The BigQuery project ID
#' @param datasetId A datasetId within projectId
#' @param tableId The tableId within the datasetId
#' 
#' Example: bqr_table_meta("publicdata", "samples", "github_nested")
#' 
#' @export
bqr_table_meta <- function(projectId, datasetId, tableId){
  
  
  f <- function(x){
    x <- rmNullObs(x)
  }
  
  
  l <- googleAuthR::gar_api_generator("https://www.googleapis.com/bigquery/v2",
                                      "GET",
                                      path_args = list(projects = projectId,
                                                       datasets = datasetId,
                                                       tables = tableId),
                                      data_parse_function = f)
  
  l(path_arguments = list(projects = projectId, 
                          datasets = datasetId, 
                          tables = tableId))
  
}

#' Get BigQuery Table's data list
#' 
#' @param projectId The BigQuery project ID
#' @param datasetId A datasetId within projectId
#' @param tableId The tableId within the datasetId
#' @param maxResults Number of results to return
#' 
#' Not very useful as can't deal with nested datasets
#' 
#' @export
bqr_table_data <- function(projectId, datasetId, tableId,
                           maxResults = 1000){
  
  l <- googleAuthR::gar_api_generator("https://www.googleapis.com/bigquery/v2",
                                      "GET",
                                      path_args = list(projects = projectId,
                                                       datasets = datasetId,
                                                       tables = tableId,
                                                       data = ""),
                                      pars_args = list(maxResults = maxResults),
                                      data_parse_function = function(x) x)
  
  l(path_arguments = list(projects = projectId, 
                          datasets = datasetId, 
                          tables = tableId),
    pars_arguments = list(maxResults = maxResults))
  
}


#' Create a Table
#' 
#' @param projectId The BigQuery project ID.
#' @param datasetId A datasetId within projectId.
#' @param tableId Name of table you want.
#' @param template_data A dataframe with the correct types of data
#' 
#' @return TRUE if created, FALSE if not.  
#' 
#' @details 
#' 
#' 
#' 
#' @export
bqr_create_table <- function(projectId, datasetId, tableId, template_data){
  
  l <- googleAuthR::gar_api_generator("https://www.googleapis.com/bigquery/v2",
                                      "POST",
                                      path_args = list(projects = projectId,
                                                       datasets = datasetId,
                                                       tables = "")
                                      )
  
  config <- list(
        schema = list(
          fields = schema_fields(template_data)
        ),
        tableReference = list(
          projectId = projectId,
          datasetId = datasetId,
          tableId = tableId
        )
  )
  
 req <- try(l(path_arguments = list(projects = projectId, 
                          datasets = datasetId),
           the_body = config), silent = TRUE)
 
 if(is.error(req)){
   if(grepl("Already Exists", error.message(req))){
     message("Table exists: ", tableId, "Returning FALSE")
     out <- FALSE
   } else {
     stop(error.message(req))
   }
 } else {
   message("Table created: ", tableId)
   out <- TRUE
 }
 
 out
  
}


#' Delete a Table
#' 
#' @param projectId The BigQuery project ID.
#' @param datasetId A datasetId within projectId.
#' @param tableId Name of table you want to delete.
#' 
#' @return TRUE if deleted, error if not.  
#' 
#' @details 
#' 
#' 
#' 
#' @export
bqr_delete_table <- function(projectId, datasetId, tableId){
  
  l <- googleAuthR::gar_api_generator("https://www.googleapis.com/bigquery/v2",
                                      "DELETE",
                                      path_args = list(projects = projectId,
                                                       datasets = datasetId,
                                                       tables = tableId)
  )
  
  req <- l(path_arguments = list(projects = projectId, 
                                     datasets = datasetId,
                                     tables = tableId), silent = TRUE)
  
  TRUE
  
}