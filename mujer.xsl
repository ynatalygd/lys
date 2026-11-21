<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <xsl:variable name="luzisombra" select="doc('esp_luz_i_sombra.xml')"/>
    <xsl:variable name="lalumiereetlombre" select="doc('fr_lalumiere_et_lombre.xml')"/>
    
    <!-- Lista de palabras para no tener en cuenta : stopwords -->
    <xsl:variable name="stopwordsEspanol" select="('que', 'de', 'y', 'la', 'el', 'en', 'un', 'una', 'con', 'por', 'para', 'se', 'su', 'le', 'les', 'lo', 'como', 'aureliana', 'habia', 'hace', 'ántes')"/>
    <xsl:variable name="stopwordsFrances" select="('que', 'de', 'et', 'elle', 'la', 'le', 'en', 'un', 'une', 'avec', 'pour', 'par', 'se', 'son', 'sa', 'ces', 'les', 'des', 'du', 'au', 'avaient', 'aureliana', 'plus', 'leur', 'leurs', 'même', 'dans', 'après', 'ainsi', 'avait', 'ceux', 'sans', 'cette')"/>
    
    <!-- Lista de personajes por género organizados por keys -->
    <xsl:variable name="personajesFemeninos" select="('#aureliana', '#donaPrudencia', '#sebastiana', '#mercedes', '#madreDeMercedes', '#madreDeAureliana', '#hijaDeAureliana', '#venerableMatrona')"/>
    <xsl:variable name="personajesMasculinos" select="('#presidente', '#gabriel', '#mariano', '#vicente', '#fernando', '#negroEsclavo', '#esposoDeAureliana', '#padreDeMercedes', '#hijosVaronesDeAureliana', '#hijosEHijaDeAureliana')"/>
    
    <xsl:template match="/">
        <html lang="fr">
            <head>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Analyse des personnages par genre</title>
                <link rel="stylesheet" href="style.css"/>
            </head>
            <body>
                <div>
                    <ul id="nav">
                        <li><a href="index.html">Accueil</a></li>
                        <li><a href="conte.html">Luz y sombra</a></li>
                        <li><a href="versionescomparadas.html">Version bilingue comparée</a></li>
                        <li><a href="mujer.html">Personnages par genre</a></li>
                        <li><a href="manuscrit.html">Manuscrit et sources</a></li>
                        <li><a href="references.html">Références complémentaires</a></li>
                        <li><a href="credits.html">Crédits</a></li>
                    </ul>
                </div>
                
                
                <h1>Análisis de personajes agrupados por género.</h1>
                <h2>Analyse des personnages regroupés par genre.</h2>
                
                <div class="language-selector">
                    <div class="botones-idioma">
                        <button onclick="mostrarSeccion('espanol')">Español</button>
                        <button onclick="mostrarSeccion('frances')">Francés</button>
                    </div>
                    
                    <!-- Sección para español -->
                    <div id="espanol" class="seccion-idioma">
                        
                        <div class="genero-container">
                            <!-- Personajes femeninos -->
                            <div class="genero">
                                <h3>Personajes Femeninos</h3>
                                <xsl:call-template name="analizar-segmentos">
                                    <xsl:with-param name="segmentos" 
                                        select="$luzisombra//tei:seg[@corresp = $personajesFemeninos]"/>
                                    <xsl:with-param name="stopwords" select="$stopwordsEspanol"/>
                                    <xsl:with-param name="idioma" select="'es'"/>
                                    <xsl:with-param name="genero" select="'femenino'"/>
                                </xsl:call-template>
                            </div>
                            
                            <!-- Personajes masculinos -->
                            <div class="genero">
                                <h3>Personajes Masculinos</h3>
                                <xsl:call-template name="analizar-segmentos">
                                    <xsl:with-param name="segmentos" 
                                        select="$luzisombra//tei:seg[@corresp = $personajesMasculinos]"/>
                                    <xsl:with-param name="stopwords" select="$stopwordsEspanol"/>
                                    <xsl:with-param name="idioma" select="'es'"/>
                                    <xsl:with-param name="genero" select="'masculino'"/>
                                </xsl:call-template>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Sección para francés -->
                    <div id="frances" class="seccion-idioma">
                        
                        <div class="genero-container">
                            <!-- Personajes femeninos -->
                            <div class="genero">
                                <h3>Personnages Féminins</h3>
                                <xsl:call-template name="analizar-segmentos">
                                    <xsl:with-param name="segmentos" 
                                        select="$lalumiereetlombre//tei:seg[@corresp = $personajesFemeninos]"/>
                                    <xsl:with-param name="stopwords" select="$stopwordsFrances"/>
                                    <xsl:with-param name="idioma" select="'fr'"/>
                                    <xsl:with-param name="genero" select="'femenino'"/>
                                </xsl:call-template>
                            </div>
                            
                            <!-- Personajes masculinos -->
                            <div class="genero">
                                <h3>Personnages Masculins</h3>
                                <xsl:call-template name="analizar-segmentos">
                                    <xsl:with-param name="segmentos" 
                                        select="$lalumiereetlombre//tei:seg[@corresp = $personajesMasculinos]"/>
                                    <xsl:with-param name="stopwords" select="$stopwordsFrances"/>
                                    <xsl:with-param name="idioma" select="'fr'"/>
                                    <xsl:with-param name="genero" select="'masculino'"/>
                                </xsl:call-template>
                            </div>
                        </div>
                    </div>
                </div>
                
                <script>
                    function mostrarSeccion(id) {
                    // Ocultar todas las secciones
                    document.querySelectorAll('.seccion-idioma').forEach(seccion => {
                    seccion.style.display = 'none';
                    });
                    
                    // Mostrar la sección seleccionada
                    document.getElementById(id).style.display = 'block';
                    }
                    
                    function resaltarPalabra(palabra, genero, idioma) {
                    // Quitar resaltados anteriores
                    document.querySelectorAll(`.resaltado-${genero}-${idioma}`).forEach(el => {
                    el.classList.remove('resaltado');
                    el.classList.remove(`resaltado-${genero}-${idioma}`);
                    });
                    
                    // Aplicar nuevo resaltado
                    document.querySelectorAll(`.fragmento-${genero}-${idioma}`).forEach(fragmento => {
                    const texto = fragmento.textContent;
                    const regex = new RegExp(`\\b${palabra}\\b`, 'gi');
                    
                    if (regex.test(texto)) {
                    fragmento.innerHTML = texto.replace(
                    regex, 
                    match => `<span class="resaltado resaltado-${genero}-${idioma}">${match}</span>`
                    );
                    }
                    });
                    }
                    
                    // Mostrar la sección de español al cargar
                    window.onload = () => mostrarSeccion('espanol');
                </script>
            </body>
        </html>
    </xsl:template>
    
    <!-- Plantilla para analizar segmentos -->
    <xsl:template name="analizar-segmentos">
        <xsl:param name="segmentos"/>
        <xsl:param name="stopwords"/>
        <xsl:param name="idioma"/>
        <xsl:param name="genero"/>
        
        <!-- Paso 1: Extraer y procesar palabras -->
        <xsl:variable name="textoCompleto">
            <xsl:value-of select="string-join($segmentos, ' ')"/>
        </xsl:variable>
        
        <xsl:variable name="palabras">
            <xsl:for-each select="tokenize(lower-case($textoCompleto), '\P{L}+')[normalize-space()]">
                <xsl:if test="string-length(.) &gt; 3 and not(. = $stopwords)">
                    <palabra><xsl:value-of select="."/></palabra>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- Paso 2: Contar frecuencia -->
        <xsl:variable name="conteo">
            <xsl:for-each-group select="$palabras/palabra" group-by=".">
                <palabra 
                    valor="{current-grouping-key()}" 
                    frecuencia="{count(current-group())}"/>
            </xsl:for-each-group>
        </xsl:variable>
        
        <!-- Paso 3: Ordenar por frecuencia -->
        <xsl:variable name="palabrasOrdenadas">
            <xsl:for-each select="$conteo/palabra">
                <xsl:sort select="@frecuencia" order="descending"/>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:variable>
        
        <!-- Mostrar palabras clave -->
        <div style="margin-bottom: 20px;">
            <h4>Palabras clave más frecuentes:</h4>
            <xsl:for-each select="$palabrasOrdenadas/palabra[position() &lt;= 15]">
                <span class="palabra" onclick="resaltarPalabra('{@valor}', '{$genero}', '{$idioma}')">
                    <xsl:value-of select="@valor"/>
                    <span class="frecuencia"><xsl:value-of select="@frecuencia"/></span>
                </span>
            </xsl:for-each>
        </div>
        
        <!-- Mostrar fragmentos originales -->
        <div>
            <h4>Fragmentos asociados:</h4>
            <xsl:for-each select="$segmentos">
                <div class="fragmento fragmento-{$genero}-{$idioma}">
                    <xsl:value-of select="."/>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>