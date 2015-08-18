module ActiveTriples::Solrizer

  # Generic ActiveTriples exception class
  class ActiveTriplesError < StandardError
  end

  # Raised when ActiveTriples cannot find the record by given id or set of ids
  class ObjectNotFoundError < ActiveTriplesError
  end

end