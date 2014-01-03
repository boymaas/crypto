#= require dataTables/jquery.dataTables
#= require dataTables/jquery.dataTables.bootstrap3

$ -> 
  $('.datatable').dataTable
    bSort: false
    bFilter: false
    bLengthChange: false
