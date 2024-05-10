"""Search hosts data set."""
from censys.search import CensysHosts



# Single page of search results
query = CensysHosts.search("services.service_name: abxs", per_page=5)
print(query())