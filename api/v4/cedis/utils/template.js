module.exports.htmlTemplate = function (crtienda, crplaza, data) {
    return `<!DOCTYPE html>
  <html lang="en">
  
  <head>
      <meta charset="UTF-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Cedis Email</title>
  </head>
  <style>
      body {
          width: 100%;
          font-family: Arial, Helvetica, sans-serif
      }
  
      p {
          margin: 2px;
      }
  
      #emailContainer {
          display: block;
          margin: 0 auto;
          height: auto;
      }
  
      #headContainer {
          top: 104px;
          left: 31px;
          margin: 0 auto;
          background: #FFFFFF 0% 0% no-repeat padding-box;
          background: #FFFFFF 0% 0% no-repeat padding-box;
          //box-shadow: 0px 4px 16px #00000029;
          //border-radius: 26px;
          opacity: 1;
          padding: 33px;
      }
  
      #headContainerImg {
        background-position: center;
        opacity: 1;
        width: 20%;
        margin: 0 auto;
        margin-bottom: 30px;
    }
  
      .placeholders,
      #entregados,
      #faltantes,
      #daniados,
      #etiquetas,
      .inputs-container,
      #devolucion,
      #devolucion-canastilla,
      #canastilla-tienda,
      #devolucion-contenedores,
      #movimiento-tienda {
          margin: 0 auto;
          padding-left: 33px;
          padding-right: 33px;
          padding-top: 13px;
          padding-bottom: 13px;
      }
  
      table {
        font-family: arial, sans-serif;
        border-collapse: collapse;
        width: 100%;
      }
      
      td, th {
        border: 1px solid #dddddd;
        text-align: left;
        padding: 15px;
      }
      
      tr:nth-child(even) {
        background-color: #dddddd;
      }
  
      .inputs {
          height: auto;
          border: 1px solid #dddddd;
          opacity: 1;
          border-radius: 10px;
          padding: 35px;
      }
  </style>
  
  <body style="box-sizing: border-box; padding: 25px;">
      <div id="emailContainer">
          <div id="headContainer">
              <div id="headContainerImg">
              <img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyBpZD0iQ2FwYV8xIiBkYXRhLW5hbWU9IkNhcGEgMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94PSIwIDAgMjA0LjMzIDEzNS40MSI+CiAgPGRlZnM+CiAgICA8c3R5bGU+CiAgICAgIC5jbHMtMSB7CiAgICAgICAgZmlsbDogIzU4ODA4YTsKICAgICAgfQoKICAgICAgLmNscy0yIHsKICAgICAgICBmaWxsOiAjZmZmOwogICAgICB9CgogICAgICAuY2xzLTMgewogICAgICAgIGZpbGw6ICNmNWU3Yjk7CiAgICAgIH0KCiAgICAgIC5jbHMtNCB7CiAgICAgICAgZmlsbDogI2ExMWQxYjsKICAgICAgfQoKICAgICAgLmNscy01IHsKICAgICAgICBmaWxsOiAjZmRjNTJiOwogICAgICB9CgogICAgICAuY2xzLTYgewogICAgICAgIGZpbGw6ICNhZmFmYWQ7CiAgICAgIH0KCiAgICAgIC5jbHMtNyB7CiAgICAgICAgZmlsbDogIzcwNmY2ZjsKICAgICAgfQoKICAgICAgLmNscy04IHsKICAgICAgICBmaWxsOiAjZTIyNjFkOwogICAgICB9CgogICAgICAuY2xzLTkgewogICAgICAgIGZpbGw6ICM2OWExYWQ7CiAgICAgIH0KCiAgICAgIC5jbHMtMTAgewogICAgICAgIGZpbGw6ICNkNWFiMzc7CiAgICAgIH0KICAgIDwvc3R5bGU+CiAgPC9kZWZzPgogIDxwYXRoIGlkPSJUcmF6YWRvXzcyMSIgZGF0YS1uYW1lPSJUcmF6YWRvIDcyMSIgY2xhc3M9ImNscy02IiBkPSJtMTk0LjA4LDM1LjI1SDEwLjMzbC0xLjQ0LTE2LjM2aDE4Ni41NmwtMS4zNywxNi4zNloiLz4KICA8cGF0aCBpZD0iVHJhemFkb183MjIiIGRhdGEtbmFtZT0iVHJhemFkbyA3MjIiIGNsYXNzPSJjbHMtNiIgZD0ibTE5MS41NCw0MS4ybC0uNCw4LjAzLTQuMzYsODYuMThIMTUuNzJsLTIuNzEtODcuMzQtLjIxLTYuODZoMTc4Ljc0WiIvPgogIDxwYXRoIGlkPSJUcmF6YWRvXzcyMyIgZGF0YS1uYW1lPSJUcmF6YWRvIDcyMyIgY2xhc3M9ImNscy0xMCIgZD0ibTE5MS41NCw0MS4ybC0uNCw4LjAzLTE3OC4xMy0xLjE2LS4yMS02Ljg2aDE3OC43NFoiLz4KICA8cGF0aCBpZD0iVHJhemFkb183MjQiIGRhdGEtbmFtZT0iVHJhemFkbyA3MjQiIGNsYXNzPSJjbHMtNSIgZD0ibTE5Nyw0NS41M2wtMTg5LjQyLTEuMjMtMS42Mi0xMS42MWgxOTIuMzlsLTEuMzYsMTIuODVaIi8+CiAgPHBhdGggaWQ9IlRyYXphZG9fNzI1IiBkYXRhLW5hbWU9IlRyYXphZG8gNzI1IiBjbGFzcz0iY2xzLTQiIGQ9Im0xOTcuOTcsMjAuODZINi42OWwtMS4xMi02LjI4aDE5My4xOGwtLjc5LDYuMjhaIi8+CiAgPHBhdGggaWQ9IlRyYXphZG9fNzI2IiBkYXRhLW5hbWU9IlRyYXphZG8gNzI2IiBjbGFzcz0iY2xzLTkiIGQ9Im0xNzUuMTMsNjYuOTRsLS4yNiwxMS4yNy0uMzcsMTUuOTFoMGwtLjIzLDkuODZoMGwtLjcsMjkuNTdoLTI5LjQ0bC0uMzMtOC41NS0uOTItMjQtMS4yNi0zMi43NCwyMy42Mi0uOTMsOS45LS4zOFoiLz4KICA8ZyBpZD0iR3J1cG9fNTE2IiBkYXRhLW5hbWU9IkdydXBvIDUxNiI+CiAgICA8ZyBpZD0iR3J1cG9fNTE1IiBkYXRhLW5hbWU9IkdydXBvIDUxNSI+CiAgICAgIDxwYXRoIGlkPSJUcmF6YWRvXzcyNyIgZGF0YS1uYW1lPSJUcmF6YWRvIDcyNyIgY2xhc3M9ImNscy0yIiBkPSJtMTc2LjA1LDY3LjJsLS4yNiwxMS4yNy0zMS4wOCw0Ni44LS45Mi0yNCwyMi4zNi0zMy42Nyw5LjktLjM5WiIvPgogICAgICA8cGF0aCBpZD0iVHJhemFkb183MjgiIGRhdGEtbmFtZT0iVHJhemFkbyA3MjgiIGNsYXNzPSJjbHMtMiIgZD0ibTE3NS40Miw5NC4zOGwtLjIzLDkuODZoMGwtMTkuNjMsMjkuNTdoLTYuMzNsMjYuMTktMzkuNDNaIi8+CiAgICA8L2c+CiAgPC9nPgogIDxwYXRoIGlkPSJUcmF6YWRvXzcyOSIgZGF0YS1uYW1lPSJUcmF6YWRvIDcyOSIgY2xhc3M9ImNscy0zIiBkPSJtMTM5LjY5LDY2LjQ3bDIuNjQsNjguOTRoMzMuMDZsMS42NS03MC40MS0zNy4zNSwxLjQ3Wm00LjQzLDY3LjA4bC0yLjUtNjUuMjksMzMuNTItMS4zMi0xLjU2LDY2LjYxaC0yOS40NVoiLz4KICA8cGF0aCBpZD0iVHJhemFkb183MzAiIGRhdGEtbmFtZT0iVHJhemFkbyA3MzAiIGNsYXNzPSJjbHMtOCIgZD0ibTIwMi45NywxOC4xOEwxLjM2LDE3LjAyLDAsNS43OGwyMDQuMzMtMS4yMy0xLjM2LDEzLjYyWiIvPgogIDxnIGlkPSJHcnVwb181MjMiIGRhdGEtbmFtZT0iR3J1cG8gNTIzIj4KICAgIDxwYXRoIGlkPSJUcmF6YWRvXzczMSIgZGF0YS1uYW1lPSJUcmF6YWRvIDczMSIgY2xhc3M9ImNscy0zIiBkPSJtMTIxLjE4LDExNy42NmwtOTEuODItMS42LTEuNzQtNTguODRoOTUuMTZsLTEuNiw2MC40NFoiLz4KICAgIDxnIGlkPSJHcnVwb181MTciIGRhdGEtbmFtZT0iR3J1cG8gNTE3Ij4KICAgICAgPHBhdGggaWQ9IlRyYXphZG9fNzMyIiBkYXRhLW5hbWU9IlRyYXphZG8gNzMyIiBjbGFzcz0iY2xzLTkiIGQ9Im0xMjAuMzksNTkuNTRsLS4zMSwxMS42OS0uNDEsMTUuMzYtLjI1LDkuNTMtLjUxLDE5LjE3LTEyLjA4LS4yMS02LjAxLS4xMS05LjY4LS4xNy0xNi4wMi0uMjgtMzEuNDctLjU1LTYuMDEtLjEtNi4wMi0uMTEtLjE2LTUuMzQtLjY5LTIzLjM2LS43NS0yNS41M2g5MC4zOFoiLz4KICAgIDwvZz4KICAgIDxnIGlkPSJHcnVwb181MTkiIGRhdGEtbmFtZT0iR3J1cG8gNTE5Ij4KICAgICAgPGcgaWQ9IkdydXBvXzUxOCIgZGF0YS1uYW1lPSJHcnVwbyA1MTgiPgogICAgICAgIDxyZWN0IGlkPSJSZWN0w6FuZ3Vsb180ODYiIGRhdGEtbmFtZT0iUmVjdMOhbmd1bG8gNDg2IiBjbGFzcz0iY2xzLTEiIHg9IjQxLjA4IiB5PSI3MS4wNiIgd2lkdGg9IjIuODgiIGhlaWdodD0iNDIuOTIiLz4KICAgICAgICA8cmVjdCBpZD0iUmVjdMOhbmd1bG9fNDg3IiBkYXRhLW5hbWU9IlJlY3TDoW5ndWxvIDQ4NyIgY2xhc3M9ImNscy0xIiB4PSI0MS4wMSIgeT0iODMuODMiIHdpZHRoPSI2NC44MSIgaGVpZ2h0PSIyLjg4Ii8+CiAgICAgICAgPHJlY3QgaWQ9IlJlY3TDoW5ndWxvXzQ4OCIgZGF0YS1uYW1lPSJSZWN0w6FuZ3VsbyA0ODgiIGNsYXNzPSJjbHMtMSIgeD0iNDEuMDEiIHk9IjEwNC41NiIgd2lkdGg9IjY0LjgxIiBoZWlnaHQ9IjIuODgiLz4KICAgICAgICA8cGF0aCBpZD0iVHJhemFkb183MzMiIGRhdGEtbmFtZT0iVHJhemFkbyA3MzMiIGNsYXNzPSJjbHMtMSIgZD0ibTc0Ljk4LDExNC41NGwtMi44OC0uMDV2LTQzLjQyaDIuODh2NDMuNDdaIi8+CiAgICAgICAgPHBhdGggaWQ9IlRyYXphZG9fNzM0IiBkYXRhLW5hbWU9IlRyYXphZG8gNzM0IiBjbGFzcz0iY2xzLTEiIGQ9Im0xMDYsMTE1LjA2bC0yLjg4LS4wOHYtNDMuOTJoMi44OHY0NFoiLz4KICAgICAgPC9nPgogICAgICA8cmVjdCBpZD0iUmVjdMOhbmd1bG9fNDg5IiBkYXRhLW5hbWU9IlJlY3TDoW5ndWxvIDQ4OSIgY2xhc3M9ImNscy0xIiB4PSI0Ni4wMyIgeT0iNzcuNCIgd2lkdGg9IjQuMjUiIGhlaWdodD0iNy4yMSIvPgogICAgICA8cmVjdCBpZD0iUmVjdMOhbmd1bG9fNDkwIiBkYXRhLW5hbWU9IlJlY3TDoW5ndWxvIDQ5MCIgY2xhc3M9ImNscy0xIiB4PSI1NC4zNyIgeT0iOTUuMzUiIHdpZHRoPSI1LjM5IiBoZWlnaHQ9IjkuMTUiLz4KICAgICAgPHJlY3QgaWQ9IlJlY3TDoW5ndWxvXzQ5MSIgZGF0YS1uYW1lPSJSZWN0w6FuZ3VsbyA0OTEiIGNsYXNzPSJjbHMtMSIgeD0iNTEuNTYiIHk9IjgwLjI3IiB3aWR0aD0iNS40NyIgaGVpZ2h0PSIzLjc1Ii8+CiAgICAgIDxyZWN0IGlkPSJSZWN0w6FuZ3Vsb180OTIiIGRhdGEtbmFtZT0iUmVjdMOhbmd1bG8gNDkyIiBjbGFzcz0iY2xzLTEiIHg9IjU3Ljg1IiB5PSI4MC4yNyIgd2lkdGg9IjUuNDciIGhlaWdodD0iMy43NSIvPgogICAgICA8cmVjdCBpZD0iUmVjdMOhbmd1bG9fNDkzIiBkYXRhLW5hbWU9IlJlY3TDoW5ndWxvIDQ5MyIgY2xhc3M9ImNscy0xIiB4PSI3Ni42NyIgeT0iOTguODUiIHdpZHRoPSI1LjQ3IiBoZWlnaHQ9IjUuNzYiLz4KICAgICAgPHJlY3QgaWQ9IlJlY3TDoW5ndWxvXzQ5NCIgZGF0YS1uYW1lPSJSZWN0w6FuZ3VsbyA0OTQiIGNsYXNzPSJjbHMtMSIgeD0iODIuOTYiIHk9Ijk4Ljg1IiB3aWR0aD0iNS40NyIgaGVpZ2h0PSI1Ljc2Ii8+CiAgICAgIDxyZWN0IGlkPSJSZWN0w6FuZ3Vsb180OTUiIGRhdGEtbmFtZT0iUmVjdMOhbmd1bG8gNDk1IiBjbGFzcz0iY2xzLTEiIHg9Ijg5LjY5IiB5PSI5OC44NSIgd2lkdGg9IjUuNDciIGhlaWdodD0iNS43NiIvPgogICAgICA8cmVjdCBpZD0iUmVjdMOhbmd1bG9fNDk2IiBkYXRhLW5hbWU9IlJlY3TDoW5ndWxvIDQ5NiIgY2xhc3M9ImNscy0xIiB4PSI5NS45OCIgeT0iOTguODUiIHdpZHRoPSI1LjQ3IiBoZWlnaHQ9IjUuNzYiLz4KICAgICAgPHJlY3QgaWQ9IlJlY3TDoW5ndWxvXzQ5NyIgZGF0YS1uYW1lPSJSZWN0w6FuZ3VsbyA0OTciIGNsYXNzPSJjbHMtMSIgeD0iNzkuODEiIHk9IjkzLjExIiB3aWR0aD0iNS40NyIgaGVpZ2h0PSI1Ljc2Ii8+CiAgICAgIDxyZWN0IGlkPSJSZWN0w6FuZ3Vsb180OTgiIGRhdGEtbmFtZT0iUmVjdMOhbmd1bG8gNDk4IiBjbGFzcz0iY2xzLTEiIHg9Ijg2LjEiIHk9IjkzLjExIiB3aWR0aD0iNS40NyIgaGVpZ2h0PSI1Ljc2Ii8+CiAgICAgIDxyZWN0IGlkPSJSZWN0w6FuZ3Vsb180OTkiIGRhdGEtbmFtZT0iUmVjdMOhbmd1bG8gNDk5IiBjbGFzcz0iY2xzLTEiIHg9IjkyLjQzIiB5PSI5My4xMSIgd2lkdGg9IjUuNDciIGhlaWdodD0iNS43NiIvPgogICAgICA8cmVjdCBpZD0iUmVjdMOhbmd1bG9fNTAwIiBkYXRhLW5hbWU9IlJlY3TDoW5ndWxvIDUwMCIgY2xhc3M9ImNscy0xIiB4PSI2Ny41OCIgeT0iNzMuMzciIHdpZHRoPSIzLjA1IiBoZWlnaHQ9IjExLjkiLz4KICAgICAgPHJlY3QgaWQ9IlJlY3TDoW5ndWxvXzUwMSIgZGF0YS1uYW1lPSJSZWN0w6FuZ3VsbyA1MDEiIGNsYXNzPSJjbHMtMSIgeD0iNjQuMzciIHk9Ijc4LjcyIiB3aWR0aD0iMi4yNiIgaGVpZ2h0PSI2LjU2Ii8+CiAgICAgIDxyZWN0IGlkPSJSZWN0w6FuZ3Vsb181MDIiIGRhdGEtbmFtZT0iUmVjdMOhbmd1bG8gNTAyIiBjbGFzcz0iY2xzLTEiIHg9Ijc3LjczIiB5PSI3OC4yNSIgd2lkdGg9IjYuOTciIGhlaWdodD0iNi4zNiIvPgogICAgICA8cmVjdCBpZD0iUmVjdMOhbmd1bG9fNTAzIiBkYXRhLW5hbWU9IlJlY3TDoW5ndWxvIDUwMyIgY2xhc3M9ImNscy0xIiB4PSI0Ni4wNSIgeT0iOTguMjkiIHdpZHRoPSI2Ljk3IiBoZWlnaHQ9IjYuMzYiLz4KICAgICAgPHJlY3QgaWQ9IlJlY3TDoW5ndWxvXzUwNCIgZGF0YS1uYW1lPSJSZWN0w6FuZ3VsbyA1MDQiIGNsYXNzPSJjbHMtMSIgeD0iNjguNDkiIHk9Ijk1LjM1IiB3aWR0aD0iMi4zIiBoZWlnaHQ9IjkuMTUiLz4KICAgICAgPHJlY3QgaWQ9IlJlY3TDoW5ndWxvXzUwNSIgZGF0YS1uYW1lPSJSZWN0w6FuZ3VsbyA1MDUiIGNsYXNzPSJjbHMtMSIgeD0iNjEuMTciIHk9Ijk4LjI5IiB3aWR0aD0iNi4xNCIgaGVpZ2h0PSI2LjM2Ii8+CiAgICAgIDxyZWN0IGlkPSJSZWN0w6FuZ3Vsb181MDYiIGRhdGEtbmFtZT0iUmVjdMOhbmd1bG8gNTA2IiBjbGFzcz0iY2xzLTEiIHg9Ijg2LjUzIiB5PSI3OC4yNSIgd2lkdGg9IjYuOTciIGhlaWdodD0iNi4zNiIvPgogICAgICA8cmVjdCBpZD0iUmVjdMOhbmd1bG9fNTA3IiBkYXRhLW5hbWU9IlJlY3TDoW5ndWxvIDUwNyIgY2xhc3M9ImNscy0xIiB4PSI5NS4zMiIgeT0iNzguMjUiIHdpZHRoPSI2Ljk3IiBoZWlnaHQ9IjYuMzYiLz4KICAgICAgPHJlY3QgaWQ9IlJlY3TDoW5ndWxvXzUwOCIgZGF0YS1uYW1lPSJSZWN0w6FuZ3VsbyA1MDgiIGNsYXNzPSJjbHMtMSIgeD0iODEuOTYiIHk9IjcxLjkiIHdpZHRoPSI2Ljk3IiBoZWlnaHQ9IjYuMzYiLz4KICAgICAgPHJlY3QgaWQ9IlJlY3TDoW5ndWxvXzUwOSIgZGF0YS1uYW1lPSJSZWN0w6FuZ3VsbyA1MDkiIGNsYXNzPSJjbHMtMSIgeD0iOTAuNTIiIHk9IjcxLjkiIHdpZHRoPSI2Ljk3IiBoZWlnaHQ9IjYuMzYiLz4KICAgIDwvZz4KICAgIDxnIGlkPSJHcnVwb181MjIiIGRhdGEtbmFtZT0iR3J1cG8gNTIyIj4KICAgICAgPGcgaWQ9IkdydXBvXzUyMCIgZGF0YS1uYW1lPSJHcnVwbyA1MjAiPgogICAgICAgIDxwYXRoIGlkPSJUcmF6YWRvXzczNSIgZGF0YS1uYW1lPSJUcmF6YWRvIDczNSIgY2xhc3M9ImNscy0yIiBkPSJtNjMuOTMsNTkuNTRsLTMyLjQ3LDQ4LjktLjY5LTIzLjM3LDE2Ljk1LTI1LjUzaDE2LjIxWiIvPgogICAgICAgIDxwYXRoIGlkPSJUcmF6YWRvXzczNiIgZGF0YS1uYW1lPSJUcmF6YWRvIDczNiIgY2xhc3M9ImNscy0yIiBkPSJtNzkuOCw1OS41NGwtMzYuMTUsNTQuNDQtNi4wMS0uMSwzNi4wOS01NC4zNGg2LjA4WiIvPgogICAgICA8L2c+CiAgICAgIDxnIGlkPSJHcnVwb181MjEiIGRhdGEtbmFtZT0iR3J1cG8gNTIxIj4KICAgICAgICA8cGF0aCBpZD0iVHJhemFkb183MzciIGRhdGEtbmFtZT0iVHJhemFkbyA3MzciIGNsYXNzPSJjbHMtMiIgZD0ibTEyMC4zOSw1OS41NGwtLjMxLDExLjY5LTI4Ljk0LDQzLjU4LTE2LjAyLS4yOCwzNi41MS01NC45OWg4Ljc2WiIvPgogICAgICAgIDxwYXRoIGlkPSJUcmF6YWRvXzczOCIgZGF0YS1uYW1lPSJUcmF6YWRvIDczOCIgY2xhc3M9ImNscy0yIiBkPSJtMTE5LjY4LDg2LjZsLS4yNSw5LjUzLTEyLjU4LDE4Ljk2LTYuMDEtLjExLDE4Ljg1LTI4LjM5WiIvPgogICAgICA8L2c+CiAgICA8L2c+CiAgPC9nPgogIDxnIGlkPSJHcnVwb181MjUiIGRhdGEtbmFtZT0iR3J1cG8gNTI1Ij4KICAgIDxyZWN0IGlkPSJSZWN0w6FuZ3Vsb181MTAiIGRhdGEtbmFtZT0iUmVjdMOhbmd1bG8gNTEwIiBjbGFzcz0iY2xzLTciIHg9IjU3LjY5IiB3aWR0aD0iODkuMjIiIGhlaWdodD0iNDkuOTkiIHJ4PSIzIiByeT0iMyIvPgogICAgPGcgaWQ9IkdydXBvXzUyNCIgZGF0YS1uYW1lPSJHcnVwbyA1MjQiPgogICAgICA8cGF0aCBpZD0iVHJhemFkb183MzkiIGRhdGEtbmFtZT0iVHJhemFkbyA3MzkiIGQ9Im0xNDAuNjIsNDIuMzJjMC0xLjA2Ljg3LTEuOTEsMS45Mi0xLjkxczEuOTEuODcsMS45MSwxLjkyYzAsMS4wNS0uODYsMS45MS0xLjkyLDEuOTEtMS4wNiwwLTEuOTItLjg2LTEuOTItMS45M20zLjM3LDBjLS4wNS0uOC0uNzUtMS40MS0xLjU1LTEuMzUtLjguMDUtMS40MS43NS0xLjM1LDEuNTUuMDUuNzYuNjksMS4zNSwxLjQ1LDEuMzUuODEtLjAxLDEuNDYtLjY4LDEuNDUtMS41LDAtLjAyLDAtLjA0LDAtLjA1bS0yLjE5LTEuMWguODFjLjUyLDAsLjguMTguOC42NC4wMi4zLS4yLjU2LS41LjU4LS4wMiwwLS4wNSwwLS4wNywwbC41OC45NmgtLjQxbC0uNTYtLjk0aC0uMjR2Ljk0aC0uNHYtMi4xOFptLjQuOTNoLjM2Yy4yNCwwLC40NS0uMDMuNDUtLjMyLDAtLjI1LS4yMy0uMy0uNDQtLjNoLS4zNnYuNjJaIi8+CiAgICAgIDxyZWN0IGlkPSJSZWN0w6FuZ3Vsb181MTEiIGRhdGEtbmFtZT0iUmVjdMOhbmd1bG8gNTExIiBjbGFzcz0iY2xzLTIiIHg9IjYyLjQiIHk9IjUuNDciIHdpZHRoPSI3OC4wMyIgaGVpZ2h0PSI0MS4wNyIgcng9IjIiIHJ5PSIyIi8+CiAgICAgIDxwYXRoIGlkPSJUcmF6YWRvXzc0MCIgZGF0YS1uYW1lPSJUcmF6YWRvIDc0MCIgY2xhc3M9ImNscy01IiBkPSJtMTM0LjI4LDcuNTNoLTY1LjdjLTIuMjcsMC00LjEsMS44My00LjExLDQuMWg3My45M2MwLTIuMjctMS44NC00LjEtNC4xMS00LjEiLz4KICAgICAgPHBhdGggaWQ9IlRyYXphZG9fNzQxIiBkYXRhLW5hbWU9IlRyYXphZG8gNzQxIiBjbGFzcz0iY2xzLTUiIGQ9Im02OC41NSw0NC40N2g2NS43YzIuMjYsMCw0LjEtMS44NCw0LjEtNC4xaDBzLTczLjkxLDAtNzMuOTEsMGMwLDIuMjcsMS44NCw0LjEsNC4xMSw0LjEiLz4KICAgICAgPHBhdGggaWQ9IlRyYXphZG9fNzQyIiBkYXRhLW5hbWU9IlRyYXphZG8gNzQyIiBjbGFzcz0iY2xzLTgiIGQ9Im04Mi45NiwyNi4wMmMwLTMuNC0yLjc2LTYuMTYtNi4xNi02LjE2cy02LjE2LDIuNzYtNi4xNiw2LjE2LDIuNzYsNi4xNiw2LjE2LDYuMTZoMGMzLjQsMCw2LjE2LTIuNzYsNi4xNi02LjE2bTQ5LjI2LDBjMC0zLjQtMi43Ni02LjE2LTYuMTYtNi4xNi0zLjQsMC02LjE2LDIuNzYtNi4xNiw2LjE2LDAsMy40LDIuNzYsNi4xNiw2LjE2LDYuMTZoMGMzLjQsMCw2LjE2LTIuNzYsNi4xNi02LjE2bTQuMSwwYzAsNS42Ny00LjU5LDEwLjI3LTEwLjI2LDEwLjI3cy0xMC4yNy00LjU5LTEwLjI3LTEwLjI2YzAtNS42Nyw0LjU5LTEwLjI3LDEwLjI2LTEwLjI3aDBjNS42NywwLDEwLjI3LDQuNTksMTAuMjcsMTAuMjZoMG0tNDkuMjUsMGMwLDUuNjctNC41OSwxMC4yNy0xMC4yNiwxMC4yNy01LjY3LDAtMTAuMjctNC41OS0xMC4yNy0xMC4yNiwwLTUuNjcsNC41OS0xMC4yNywxMC4yNi0xMC4yN2gwYzUuNjcsMCwxMC4yNyw0LjYsMTAuMjcsMTAuMjZtNTEuMzMsMTIuM1YxMy42OGgtMTQuMDVjLTEuNTIuMDEtNC42Ni4zMS03Ljc3LDMuOTZsLTYuNSw4LjUyLDUuMzIsNi44Yy43Ljg5LjU0LDIuMTktLjM2LDIuODgtLjg5LjctMi4xOS41NC0yLjg4LS4zNmgwbC00LjY4LTYtMy41NCw0LjUyLS4wMy4wNC0xLjExLDEuNDNjLS43Ljg5LTEuOTksMS4wNi0yLjg4LjM2LS41Ni0uNDQtLjg2LTEuMTMtLjc4LTEuODQuMDQtLjM4LjE5LS43NS40My0xLjA1bDEuOTgtMi41NCwzLjMyLTQuMjYtMi4yMi0yLjg2LDIuNTUtMy40LDIuMjcsMi45Myw1LjU3LTcuMDhjLjE1LS4yLDEuMjQtMS44LDIuNDEtMi4wNmgtNTAuOTh2MjQuNjRoMTQuNTRjMS42NC0uMSw0LjQ1LS43MSw3LjI0LTMuOTdsNi41LTguNTItNS4zMi02LjhjLS42OC0uOS0uNS0yLjE5LjQtMi44OC44OC0uNjcsMi4xNC0uNTEsMi44My4zNWw0LjY5LDYsMy41My00LjUyLjA0LS4wNSwxLjEyLTEuNDJjLjY5LS44OSwxLjk4LTEuMDUsMi44Ny0uMzYuNTYuNDQuODYsMS4xMy43OCwxLjg0LS4wNC4zOC0uMTguNzUtLjQyLDEuMDVsLTEuOTgsMi41NC0zLjMzLDQuMjYsMi4yNSwyLjg4LTIuNTYsMy40LTIuMy0yLjk1LTUuNTcsNy4wOGMtLjE1LjItMS4zMSwxLjktMi41MiwyLjA3aDUxLjE0WiIvPgogICAgPC9nPgogIDwvZz4KPC9zdmc+"
                    alt=""></div></div>
              <div id="headContent">
                  <p style="
                  text-align: left;
                  font: normal normal medium 20px/50px Helvetica;
                  letter-spacing: 3px;
                  color: #666666;
                  text-transform: uppercase;
                  opacity: 1;">RUTA: ${data?.Nu_Ruta}</p>
                  <p style="
                  text-align: left;
                  font: normal normal bold 27px/45px Helvetica;
                  letter-spacing: 1.92px;
                  color: #404040;
                  opacity: 1;">CR Tienda: ${crtienda}</p>
                  <p style="
                  text-align: left;
                  font: normal normal normal 19px/34px Helvetica;
                  letter-spacing: 0px;
                  color: #666666;
                  opacity: 1;">Nombre Tienda: ${data?.Tienda}</p>
                  <p style="
                  text-align: left;
                  font: normal normal normal 19px/34px Helvetica;
                  letter-spacing: 0px;
                  color: #666666;
                  opacity: 1;">Líder de Tienda: ${data?.Lider_Tienda}</p>
                  <p style="
                  text-align: left;
                  font: normal normal bold 19px/34px Helvetica;
                  letter-spacing: 0px;
                  color: #666666;
                  opacity: 1;">Transferencia: ${data?.Transferencia}</p>
              </div>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 25px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">FORMATO ÚNICO DE ENTREGA</p>
  
              <p style="
              margin-top: 25px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">ENTREGADOS</p>
          </div>
  
          <div id="entregados">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>TIPO CONTENEDOR</th>
                      <th>TOTAL PEDIDO</th>
                      <th>TOTAL ENTREGADO</th>
                  </tr>
                  <tr>
                      <td>Caja</td>
                      <td>${data?.Entregados.cajas.total_pedido}</td>
                      <td>${data?.Entregados.cajas.total_entregado}</td>
                  </tr>
                  <tr>
                      <td>Canastillas Secos</td>
                      <td>${data?.Entregados.secos.total_pedido}</td>
                      <td>${data?.Entregados.secos.total_entregado}</td>
                  </tr>
                  <tr>
                      <td>Canastillas Refrigerados</td>
                      <td>${data?.Entregados.refrigerados.total_pedido}</td>
                      <td>${data?.Entregados.refrigerados.total_entregado}</td>
                  </tr>
                  <tr>
                      <td style="font-weight: bold">Total Bultos</td>
                      <td>${data?.Entregados.total.total_pedido}</td>
                      <td>${data?.Entregados.total.total_entregado}</td>
                  </tr>
              </table>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 15px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">ENTRADA DE CAJAS SIN ETIQUETA/ETIQUETAS DAÑADAS</p>
          </div>

          <div id="etiquetas">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>DESCRIPCIÓN</th>
                      <th>CÓDIGO CONTENEDOR</th>
                  </tr>
                  ${data?.etiquetas_danadas.map(item => {
                        return `<tr>
                                    <td>${item?.tipo_contenedor}</td>
                                    <td>${item?.codigo_contenedor}</td>
                                </tr>`
                        }).join('')
                  }         
                  <tr>
                    <td style="font-weight: bold">Total</td>
                    <td>${data?.etiquetas_danadas?.length}</td>
                  </tr>
              </table>
          </div>


          <div class="placeholders">
              <p style="
              margin-top: 15px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">FALTANTES</p>
          </div>
  
          <div id="faltantes">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>TIPO CONTENEDOR</th>
                      <th>CÓDIGO CONTENEDOR</th>
                      <th>TOTAL</th>
                  </tr>
                  <tr>
                      <td style="font-weight: bold">Cajas</td>
                      <td></td>
                      <td>${data?.Faltantes.cajas.total_faltantes}</td>
                  </tr>
                  ${data?.Faltantes.cajas_items.map(item => {
                        return `<tr>
                                    <td>${item?.tipo_contenedor}</td>
                                    <td>${item?.codigo_contenedor}</td>
                                    <td>${item?.total}</td>
                                    </tr>`
                        }).join('')
                  }         
                  <tr>
                    <td style="font-weight: bold">Canastillas Secos</td>
                    <td></td>
                    <td>${data?.Faltantes.secos.total_faltantes}</td>
                  </tr>
                ${data?.Faltantes.secos_items.map(item => {
                        return `<tr>
                                <td>${item?.tipo_contenedor}</td>
                                <td>${item?.codigo_contenedor}</td>
                                <td>${item?.total}</td>
                                </tr>`
                    }).join('')
                }

                <tr>
                  <td style="font-weight: bold">Canastillas Refrigerados</td>
                  <td></td>
                  <td>${data?.Faltantes.refrigerados.total_faltantes}</td>
                </tr>
              ${data?.Faltantes.refrigerados_items.map(item => {
                    return `<tr>
                            <td>${item?.tipo_contenedor}</td>
                            <td>${item?.codigo_contenedor}</td>
                            <td>${item?.total}</td>
                        </tr>`
                }).join('')
              }    
              </table>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 15px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">SOBRANTES</p>
          </div>
  
          <div id="faltantes">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>CÓDIGO CONTENEDOR</th>
                  </tr>
                  ${data?.Sobrantes_danados?.Sobrantes.map(item => {
            return `<tr>
                                    <td>${item}</td>
                                </tr>`
        }).join('')
        }
                  <tr>
                      <td><b>Total</b> ${data?.Sobrantes_danados?.Total.total_sobrantes}</td>
                  </tr>
              </table>
          </div>

          <div class="placeholders">
              <p style="
              margin-top: 15px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">DAÑADOS</p>
          </div>
  
          <div id="daniados">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>CÓDIGO ARTÍCULO</th>
                      <th>DAÑADOS</th>
                  </tr>
                  ${data?.Sobrantes_danados?.Daniados.map(item => {
            return `<tr>
                                    <td>${item?.codigo_contenedor}</td>
                                    <td>${item?.daniados}</td>
                                </tr>`
        }).join('')
        }
                  <tr>
                      <td><b>Total</b></td>
                      <td>${data?.Sobrantes_danados?.Total.total_danados}</td>
                  </tr>
              </table>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 15px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">FIRMA FALTANTE/SOBRANTE/DAÑADO</p>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal normal 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #666666;
              text-transform: uppercase;
              opacity: 1;">Observaciones Área distribución</p>
          </div>
  
          <div class="inputs-container">
              <div class="inputs">
                  <p style="padding: 10px; text-align: center;">${data?.Firma_Faltante?.Observaciones_AreaDistribucion}</p>
              </div>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal normal 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #666666;
              text-transform: uppercase;
              opacity: 1;">Firma Área distribución</p>
          </div>
  
          <div class="inputs-container">
              <div class="inputs">
                  <img src="data:image/png;base64,${data?.Firma_Faltante?.Firma_area_distribucion}"
                      alt="" style="display: block; padding: 10px; width: 115px; margin: 0 auto;">
              </div>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal normal 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #666666;
              text-transform: uppercase;
              opacity: 1;">Observaciones Personal Tienda</p>
          </div>
  
          <div class="inputs-container">
              <div class="inputs">
                  <p style="padding: 10px; text-align: center;">${data?.Firma_Faltante.Observaciones_Personal_tienda}</p>
              </div>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal normal 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #666666;
              text-transform: uppercase;
              opacity: 1;">Firma Personal Tienda</p>
          </div>
  
          <div class="inputs-container">
              <div class="inputs">
                  <img src="data:image/png;base64,${data?.Firma_Faltante?.Firma_Personal_tienda}"
                      alt="" style="display: block; padding: 10px; width: 115px; margin: 0 auto;">
              </div>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">DEVOLUCIÓN DE MERCANCÍA</p>
          </div>
  
          <div id="devolucion">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>CÓDIGO CONTENEDOR</th>
                  </tr>
                  ${data?.Devolucion_mercancia?.Codigo_contenedor.map(item => {
            return `<tr>
                                        <td>${item.codigo}</td>
                                    </tr>`
        }).join('')
        }
                  <tr>
                      <td style="font-weight: bold">Total ${data?.Devolucion_mercancia?.Total}</td>
                  </tr>
              </table>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">DEVOLUCIÓN DE CANASTILLA</p>
          </div>
  
          <div id="devolucion-canastilla">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>CÓDIGO CONTENEDOR</th>
                  </tr>
                  ${data?.Devolucion_canastillas?.Codigo_contenedor.map(item => {
            return `<tr>
                                                        <td>${item.codigo}</td>
                                                    </tr>`
        }).join('')
        }
                  <tr>
                      <td style="font-weight: bold">Total ${data?.Devolucion_canastillas?.Total}</td>
                  </tr>
              </table>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">CANASTILLA EN TIENDA</p>
          </div>
  
          <div id="canastilla-tienda">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>CÓDIGO CONTENEDOR</th>
                  </tr>
                  ${data?.canastilla_tienda?.Codigo_contenedor.map(item => {
            return `<tr>
                                                                        <td>${item.codigo}</td>
                                                                    </tr>`
        }).join('')
        }
                  <tr>
                      <td style="font-weight: bold">Total ${data?.canastilla_tienda?.Total}</td>
                  </tr>
              </table>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">DEVOLUCIÓN DE CONTENEDORES</p>
          </div>
  
          <div id="devolucion-contenedores">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>TIPO CONTENEDOR</th>
                      <th>TOTAL</th>
                  </tr>
                  ${data?.devolucion_contenedores?.contenedores.map(item => {
            return `<tr>
                                <td>${item.tipo_contenedor}</td>
                                <td>${item.total}</td>
                                </tr>`
        }).join('')
        }
                  <tr>
                      <td style="font-weight: bold">Total</td>
                      <td>${data?.devolucion_contenedores?.Total}</td>
                  </tr>
              </table>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 15px;
              text-align: left;
              font: normal normal bold 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #404040;
              text-transform: uppercase;
              opacity: 1;">FIRMA DEVOLUCIONES</p>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal normal 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #666666;
              text-transform: uppercase;
              opacity: 1;">Observaciones Área distribución</p>
          </div>
  
          <div class="inputs-container">
              <div class="inputs">
                  <p style="padding: 10px; text-align: center;">${data?.Firma_devoluciones.Observaciones_AreaDistribucion}</p>
              </div>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal normal 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #666666;
              text-transform: uppercase;
              opacity: 1;">Firma Área distribución</p>
          </div>
  
          <div class="inputs-container">
              <div class="inputs">
                  <img src="data:image/png;base64,${data?.Firma_devoluciones.Firma_area_distribucion}"
                      alt="" style="display: block; padding: 10px; width: 115px; margin: 0 auto;">
              </div>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal normal 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #666666;
              text-transform: uppercase;
              opacity: 1;">Observaciones Personal Tienda</p>
          </div>
  
          <div class="inputs-container">
              <div class="inputs">
                  <p style="padding: 10px; text-align: center;">${data?.Firma_devoluciones.Observaciones_Personal_tienda}</p>
              </div>
          </div>
  
          <div class="placeholders">
              <p style="
              margin-top: 10px;
              text-align: left;
              font: normal normal normal 22px/33px Helvetica;
              letter-spacing: 0px;
              color: #666666;
              text-transform: uppercase;
              opacity: 1;">Firma Personal Tienda</p>
          </div>
  
          <div class="inputs-container">
              <div class="inputs">
                  <img src="data:image/png;base64,${data?.Firma_devoluciones.Firma_Personal_tienda}"
                      alt="" style="display: block; padding: 10px; width: 115px; margin: 0 auto;">
              </div>
          </div>
  
          <div id="movimiento-tienda">
              <table>
                  <tr style="
                  background: #333399;
                  border-radius: 8px 8px 0px 0px;
                  opacity: 1;
                  color: white;">
                      <th>MOVIMIENTO TIENDA</th>
                      <th>BOL</th>
                  </tr>
                  ${data?.Movimientos.map(item => {
            return `<tr>
                                    <td>${item.movimiento_tienda}</td>
                                    <td>${item.BOL}</td>
                                </tr>`
        }).join('')
        }
                
              </table>
          </div>
  
      </div>
  </body>
  
  </html>`
}