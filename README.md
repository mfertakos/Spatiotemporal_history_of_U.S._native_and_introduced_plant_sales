# Spatiotemporal_history_of_U.S._native_and_introduced_plant_sales
Code and associated files for database paper: "Historical plant sales (HPS) database: Documenting the spatiotemporal history of native and introduced plant sales in the conterminous U.S."

1. **BHL-search.py**: Python script using the Biodiversity Heritage Libraries web API to scrape all records for each scientific name inputted. 
    - ***Needed files*** 
      - *‘SeedCatalogNames.csv’* -file with list of species to be searched: 
      - API key - see https://www.biodiversitylibrary.org/docs/api3.html
      - Also see *‘BHL Search Instructions.txt’*
    - ***Created files***: 
      - ‘Api_cache’ folder containing JSON data for each species. This data turns into a data table in ‘BHL_API_assembledge.R’
		
2. **BHL_API_assembledge.R**: Turn API results into a useable dataframe
	  - ***Needed files***:
		   - Folder containing JSON files for each species searched
	  - ***Created files***:
		   - *BHL_results_ofc.csv* - dataframe of assembled API results

3. **BHL_cleaning.R**: Clean/append dataframe and create three separate database files.
	- ***Needed files***:
		- *BHL_results_ofc.csv* - dataframe of assembled API results
        - *usdacodes_BHL.txt* - file contains all USDA codes, and USDA codes without periods (var. -> var) to account for variations in names
        - *taxa_to_code_fix_novarspp.txt* - contains scientific names where USDA code was found by hand
       	- *USDAgrowthhabitbyUSDAid.csv* - contains USDA codes and their respective growth habits
        - *BHL_GPI.csv* - contains all invasive species in the GPI database and their corresponding USDA codes for matching
        - *geocodelocation_geocodio.csv* - this file was generated using all unique localities in the dataset input to the geocoding website to receive lat/longs using the website geocod.io
        - *HistUSOrnPlants_Adams_2004.csv* - dataset from Restoring American Gardens (Adams 2004) appended to data from BHL.
        - *coords_geocodio.csv* - this file was generated using all unique lat/longs in the dataset to receive uniform state and municipality information using the website geocod.io.
    - ***Created files***:
      - *HPS_records.csv* - A comma delimited table of the plant species offered for sale by nurseries located in the lower 48 United States
      - *HPS_taxa.csv* - A comma delimited table of all unique plant taxa with resolved taxonomy. Columns for invasive status, growth habit, and the number of records per species are included.
