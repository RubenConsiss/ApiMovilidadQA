const dbg = false;

exports.merma_cafe = (req, res, next) => {

if(dbg) console.log("[9] Start mermacafe_get ...");

let stmt = {
            "coffeWasteDate": "01/12/2022",
            "lastcoffeWasteDate": "12/12/2022",
            "grains": [
                {
                    "type": "regular",
                    "name": "Grano regular",
                    "totalSale": 0,
                    "advisorWaste": 0,
                    "authorizedWaste": 0,
                    "ouncesByBags": 0,
                    "grainInBags": 788,
                    "ouncesInBowls": 0,
                    "physicalInventory": 0,
                    "theoreticalInventory": 0,
                    "differenceInInventory": 0,
                    "waterWaste": 0,
                    "coffees": [
                        {
                            "coffeType": "Café clásico",
                            "startCount": 0,
                            "endCount": 0,
                            "thermosPrepared": 0,
                            "ouncesByThermo": 60,
                            "ouncesPrepared": 0
                        },
                        {
                            "coffeType": "Café intenso",
                            "startCount": 0,
                            "endCount": 0,
                            "thermosPrepared": 0,
                            "ouncesByThermo": 60,
                            "ouncesPrepared": 0
                        }
                    ]
                },
                {
                    "type": "descafeinado",
                    "name": "Grano descafeinado",
                    "totalSale": 0,
                    "advisorWaste": 0,
                    "authorizedWaste": 0,
                    "ouncesByBags": 0,
                    "grainInBags": 788,
                    "ouncesInBowls": 0,
                    "physicalInventory": 0,
                    "theoreticalInventory": 0,
                    "differenceInInventory": 0,
                    "waterWaste": 0,
                    "coffees": [
                        {
                            "coffeType": "Café descafeinado",
                            "startCount": 0,
                            "endCount": 0,
                            "thermosPrepared": 0,
                            "ouncesByThermo": 60,
                            "ouncesPrepared": 0
                        }
                    ]
                },
                {
                    "type": "temporada",
                    "name": "Grano de temporada",
                    "totalSale": 0,
                    "advisorWaste": 0,
                    "authorizedWaste": 0,
                    "ouncesByBags": 0,
                    "grainInBags": 60,
                    "ouncesInBowls": 0,
                    "physicalInventory": 0,
                    "theoreticalInventory": 0,
                    "differenceInInventory": 0,
                    "waterWaste": 0,
                    "coffees": [
                        {
                            "coffeType": "Café de temporada",
                            "startCount": 0,
                            "endCount": 0,
                            "thermosPrepared": 0,
                            "ouncesByThermo": 60,
                            "ouncesPrepared": 0
                        }
                    ]
                }
            ]
};

res.status(200).json(stmt);
  
};