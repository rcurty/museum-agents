import os
import pandas as pd

COORDS = [
    {"Museum": "Getty Center", "City": "Los Angeles", "Region": "Los Angeles Area", "Lat": 34.0780, "Lng": -118.4741, "Website": "https://www.getty.edu"},
    {"Museum": "Getty Villa", "City": "Pacific Palisades", "Region": "Los Angeles Area", "Lat": 34.0459, "Lng": -118.5653, "Website": "https://www.getty.edu/visit/villa/"},
    {"Museum": "Los Angeles County Museum of Art (LACMA)", "City": "Los Angeles", "Region": "Los Angeles Area", "Lat": 34.0639, "Lng": -118.3592, "Website": "https://www.lacma.org"},
    {"Museum": "The Broad", "City": "Los Angeles", "Region": "Los Angeles Area", "Lat": 34.0545, "Lng": -118.2504, "Website": "https://www.thebroad.org"},
    {"Museum": "California Science Center", "City": "Los Angeles", "Region": "Los Angeles Area", "Lat": 34.0158, "Lng": -118.2862, "Website": "https://californiasciencecenter.org"},
    {"Museum": "Natural History Museum of LA County", "City": "Los Angeles", "Region": "Los Angeles Area", "Lat": 34.0170, "Lng": -118.2888, "Website": "https://nhm.org"},
    {"Museum": "Academy Museum of Motion Pictures", "City": "Los Angeles", "Region": "Los Angeles Area", "Lat": 34.0633, "Lng": -118.3608, "Website": "https://www.academuseum.org"},
    {"Museum": "Griffith Observatory", "City": "Los Angeles", "Region": "Los Angeles Area", "Lat": 34.1184, "Lng": -118.3004, "Website": "https://griffithobservatory.org"},
    {"Museum": "California African American Museum", "City": "Los Angeles", "Region": "Los Angeles Area", "Lat": 34.0153, "Lng": -118.2833, "Website": "https://caammuseum.org"},
    {"Museum": "Petersen Automotive Museum", "City": "Los Angeles", "Region": "Los Angeles Area", "Lat": 34.0624, "Lng": -118.3612, "Website": "https://www.petersen.org"},
    {"Museum": "de Young Museum", "City": "San Francisco", "Region": "SF Bay Area", "Lat": 37.7715, "Lng": -122.4687, "Website": "https://www.famsf.org"},
    {"Museum": "San Francisco Museum of Modern Art (SFMOMA)", "City": "San Francisco", "Region": "SF Bay Area", "Lat": 37.7857, "Lng": -122.4011, "Website": "https://www.sfmoma.org"},
    {"Museum": "California Academy of Sciences", "City": "San Francisco", "Region": "SF Bay Area", "Lat": 37.7699, "Lng": -122.4661, "Website": "https://www.calacademy.org"},
    {"Museum": "Exploratorium", "City": "San Francisco", "Region": "SF Bay Area", "Lat": 37.8015, "Lng": -122.3973, "Website": "https://www.exploratorium.edu"},
    {"Museum": "Legion of Honor", "City": "San Francisco", "Region": "SF Bay Area", "Lat": 37.7845, "Lng": -122.5008, "Website": "https://www.famsf.org"},
    {"Museum": "Asian Art Museum", "City": "San Francisco", "Region": "SF Bay Area", "Lat": 37.7802, "Lng": -122.4162, "Website": "https://www.asianart.org"},
    {"Museum": "Oakland Museum of California", "City": "Oakland", "Region": "SF Bay Area", "Lat": 37.7986, "Lng": -122.2635, "Website": "https://museumca.org"},
    {"Museum": "Computer History Museum", "City": "Mountain View", "Region": "SF Bay Area", "Lat": 37.4148, "Lng": -122.0772, "Website": "https://computerhistory.org"},
    {"Museum": "San Diego Museum of Art", "City": "San Diego", "Region": "San Diego Area", "Lat": 32.7319, "Lng": -117.1504, "Website": "https://www.sdmart.org"},
    {"Museum": "San Diego Natural History Museum", "City": "San Diego", "Region": "San Diego Area", "Lat": 32.7321, "Lng": -117.1473, "Website": "https://www.sdnhm.org"},
    {"Museum": "San Diego Air & Space Museum", "City": "San Diego", "Region": "San Diego Area", "Lat": 32.7262, "Lng": -117.1542, "Website": "https://sandiegoairandspace.org"},
    {"Museum": "USS Midway Museum", "City": "San Diego", "Region": "San Diego Area", "Lat": 32.7137, "Lng": -117.1751, "Website": "https://www.midway.org"},
    {"Museum": "Museum of Contemporary Art San Diego (MCASD)", "City": "La Jolla", "Region": "San Diego Area", "Lat": 32.8466, "Lng": -117.2771, "Website": "https://mcasd.org"},
    {"Museum": "California State Railroad Museum", "City": "Sacramento", "Region": "Sacramento Region", "Lat": 38.5839, "Lng": -121.5042, "Website": "https://www.railroadmuseum.org"},
    {"Museum": "Crocker Art Museum", "City": "Sacramento", "Region": "Sacramento Region", "Lat": 38.5772, "Lng": -121.5033, "Website": "https://www.crockerart.org"},
    {"Museum": "California Museum", "City": "Sacramento", "Region": "Sacramento Region", "Lat": 38.5752, "Lng": -121.4939, "Website": "https://www.californiamuseum.org"},
    {"Museum": "Santa Barbara Museum of Art", "City": "Santa Barbara", "Region": "Central Coast", "Lat": 34.4231, "Lng": -119.7049, "Website": "https://www.sbmuseumofart.org"},
    {"Museum": "Monterey Bay Aquarium", "City": "Monterey", "Region": "Central Coast", "Lat": 36.6182, "Lng": -121.9015, "Website": "https://www.montereybayaquarium.org"},
    {"Museum": "Norton Simon Museum", "City": "Pasadena", "Region": "Los Angeles Area", "Lat": 34.1460, "Lng": -118.1601, "Website": "https://www.nortonsimon.org"},
    {"Museum": "Ronald Reagan Presidential Library", "City": "Simi Valley", "Region": "Southern California", "Lat": 34.2597, "Lng": -118.8197, "Website": "https://www.reaganlibrary.gov"}
]

os.makedirs('museum-agents/data', exist_ok=True)

# Copy exhibitions.csv
exhibitions_df = pd.read_csv('museum/exhibitions.csv')
exhibitions_df.to_csv('museum-agents/data/exhibitions.csv', index=False)

# Write museum_coords.csv
coords_df = pd.DataFrame(COORDS)
coords_df.to_csv('museum-agents/data/museum_coords.csv', index=False)

print("Data files successfully prepared in museum-agents/data/")
