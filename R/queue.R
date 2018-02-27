new_target_queue <- function(config){
  config$graph <- config$execution_graph
  targets <- V(config$graph)$name
  priorities <- lightly_parallelize(
    X = targets,
    FUN = function(target){
      length(dependencies(targets = target, config = config))
    },
    jobs = config$jobs
  ) %>%
    unlist
  stopifnot(any(priorities < 1)) # Stop if nothing has ready deps.
  fheap <- fibonacci_heap("integer", "character")
  insert(obj = fheap, x = priorities, y = targets)
}

pop0 <- function(queue, tol = 1e-6){
  top_value <- unlist(peek(fheap), use.names = FALSE)
  top_meta <- handle(fheap, value = top_value)[[1]]
  top_key <- top_meta$key
  if (abs(top_key) < tol){
    unlist(pop(fheap), use.names = FALSE)
  } else {
    NULL
  }
}
