module.exports.validate = function (body) {
  const properties = [
    "CrPlaza",
    "CrTienda",
    "DateTime",
    "Supplier",
    "SupplierName",
    "RegistroVisita"
  ];

  if ("CrPlaza" in body &&
    "CrTienda" in body &&
    "DateTime" in body &&
    "Supplier" in body &&
    "SupplierName" in body &&
    "RegistroVisita" in body
  ) {
    return true
  }

  return false;
}