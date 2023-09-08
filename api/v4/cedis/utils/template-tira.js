module.exports.htmlTira = function (crtienda, crplaza, data) {
    return `<!DOCTYPE html>
    <html lang="en" dir="ltr">
        <head>
            <meta charset="utf-8">
            <title></title>
    
            <style media="screen">

                body{
                    font-family: arial;
                }

                .information,
                .warehouse-transfer,
                .records,
                .total,
                .footer{
                    width: 500px;
                    padding: 7px 10%;
                    margin: auto;
                }

                .title{
                    font-weight: bold;
                }

                .text-center{
                    text-align: center;
                }
                .text-left{
                    text-align: center;
                }
                .text-right{
                    text-align: center;
                }

                .row-1,.row-2{
                    display: flex;
                }
                .row-1 > div,
                .row-2 > div{
                    padding: 0px 3px;
                }

                .row-1 > div:first-child{
                    width: 35%;
                }
                
                .row-1 > div:last-child{
                    width: 65%;
                }

                .row-2 > div{
                    width: 25%;
                }
                .row-2 > div:first-child{
                    width: 20%;
                }

                .header .row-2 > div{
                    text-align: right;
                }

                .body .row-2 > div{
                    text-align: right;
                }                

                .separator{
                    height: 2px;
                    width: 100%;
                    background:  #000000;
                    margin: 10px 0px;
                }

                .records .body{
                    text-transform: uppercase;
                }

                .total table{
                    width: 100%;
                    font-weight: bold;
                }

                .total table td{
                    text-align: right;
                }

                .total table td:first-child{
                    text-align: left;
                }

                .footer{
                    text-align: center;
                }

                .footer p{
                    margin: 0;
                }

                .dashed{
                    height: 10px;
                    width: 100%;
                    border-top: 1px dashed #000000;
                }
            </style>
    
        </head>
        <body>
            <div class="information">
                <p class="title text-center">Cadena Comercial Oxxo, S.A. de C.V.</p>
                <table>
                    <tr colspan = "4">
                        <td>PLAZA:</td>
                        <td>${data?.ticket.crPlace} &nbsp;&nbsp;&nbsp; ${data?.ticket.placeName}</td>
                    </tr>
                    <tr colspan = "4">
                        <td>TIENDA:</td>
                        <td>${data?.ticket.crStore} &nbsp;&nbsp;&nbsp; ${data?.ticket.storeName}</td>
                    </tr>
                    <tr>
                        <td>FECHA:</td>
                        <td>${data?.Fecha}</td>
                        <td>HORA:</td>
                        <td>${data?.Hora_Entrega}</td>
                    </tr>
                    <tr colspan = "4">
                        <td>FECHA ADMVA.:</td>
                        <td>${data?.ticket.administrativeDate}</td>
                    </tr>
                </table>
            </div>
            <div class="warehouse-transfer">
                <p class="title">Transferencia de Almacén</p>
                <table>
                    <tr>
                        <td>FOLIO:</td>
                        <td>${data?.ticket.folioPOS} (${data?.ticket.purchaseOrderId})</td>
                    </tr>
                    <tr>
                        <td>Transfer Num:</td>
                        <td>${data?.ticket.transferNo}</td>
                    </tr>
                    <tr>
                        <td>Bill of Landing:</td>
                        <td>${data?.ticket.billOfLading}</td>
                    </tr>
                    <tr>
                        <td>${data?.ticket.supplierName}</td>
                        <td>${data?.ticket.supplierId}</td>
                    </tr>
                    <tr>
                        <td>ST:</td>
                        <td>O.K.</td>
                    </tr>
                    <tr>
                        <td>REMISION:</td>
                        <td>${data?.ticket.remision}</td>
                    </tr>
                </table>
            </div>
            <br>
            <div class="records">
                <div class="header">
                    <div class="row-1">
                        <div>CLAVE ARTICULO</div>
                        <div>DESCRIPTION</div>
                    </div>
                    <div class="row-2">
                        <div>COSTO UB</div>
                        <div>PREC+IVA UDS.</div>
                        <div>UDS.COM</div>
                        <div>VLTOT</div>
                    </div>
                </div>
                <div class="separator"></div>
                ${data?.ticket.receivedItemArray.map(item => {
                    return `<div class="body">
                                <div class="row-1">
                                    <div>${item?.sku}</div>
                                    <div>${item?.nombre}</div>
                                </div>
                                <div class="row-2">
                                    <div>${item?.item_cost}</div>
                                    <div>${item?.item_price}</div>
                                    <div>${item?.cant}</div>
                                    <div>${item?.item_total}</div>
                                </div>
                            </div>`
                    }).join('')
                }
            </div>
            </br>
            <div class="total">
            <table>
                <tr>
                    <td>TOT. TASA FIS. 0.00%</td>
                    <td>$</td>
                    <td>${data?.ticket.totalTax0}</td>
                </tr>
                <tr>
                    <td>TOT. TASA FIS. 16.00%</td>
                    <td>$</td>
                    <td>${data?.ticket.totalTax16}</td>
                </tr>
                <tr>
                    <td>TOTAL GENERAL A VENTA</td>
                    <td>$</td>
                    <td>${data?.ticket.totalSale}</td>
                </tr>
                <tr>
                    <td>MOVTS. VALORIZADOS</td>
                    <td></td>
                    <td>${data?.ticket.totalCount}</td>
                </tr>
                <tr>
                    <td>TOTAL DE COSTO</td>
                    <td>$</td>
                    <td>${data?.ticket.totalCost}</td>
                </tr>
                <tr>
                    <td>UNIDADES SURTIDAS</td>
                    <td></td>
                    <td>${data?.ticket.units}</td>
                </tr>
            </table>
        </div>
        <div class="footer">
            <div class="dashed"></div>
            <p>TIENDA</p>
            <p> >>><<< FINAL DEL REPORTE >>><<< </p>
        </div>
        </body>
    </html>`
}