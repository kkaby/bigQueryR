% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/uploadData.R
\name{bqr_upload_data}
\alias{bqr_upload_data}
\title{Upload data to BigQuery}
\usage{
bqr_upload_data(projectId, datasetId, tableId, upload_data, create = TRUE,
  overwrite = FALSE, uploadType = c("multipart", "resumable"))
}
\arguments{
\item{projectId}{The BigQuery project ID.}

\item{datasetId}{A datasetId within projectId.}

\item{tableId}{ID of table where data will end up.}

\item{upload_data}{The data to upload, a data.fame.}

\item{create}{If TRUE will create the table if it isn't present.}

\item{overwrite}{If TRUE will delete any existing table and upload new data.}

\item{uploadType}{'multipart' for small data, 
'resumable' for big. (not implemented yet)}
}
\value{
TRUE if successful, FALSE if not.
}
\description{
Upload data to BigQuery
}
\details{
A temporary csv file is created when uploading.
}

