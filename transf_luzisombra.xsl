<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="3.0">
    
    <!-- Aquí definimos que vamos a generar un html a partir de un o de archivos xml -->
    <xsl:output method="html" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
    
    <!-- cargamos los XML. Como son dos, hay que cargarlos como variable -->
    <xsl:variable name="luzisombra" select="doc('esp_luz_i_sombra.xml')"/>
    <xsl:variable name="lalumiereetlombre" select="doc('fr_lalumiere_et_lombre.xml')"/>
    
    <!-- pour regruper par le id key -->
    <xsl:key name="persNameByKey" match="tei:persName" use="@key"/>
    <xsl:key name="placeNameByKey" match="tei:placeName" use="@key"/>
    <xsl:key name="orgNameByKey" match="tei:orgName" use="@key"/>
    
    <!-- Template principal para el  HTML -->
    <xsl:template match="/">
        <html lang="fr">
            <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                                
                                <title>Édition numérique de « Luz y sombra » de Soledad Acosta</title>
                                
                                <link rel="stylesheet" href="style.css"/>
                                    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
                                           
                                        <!-- Inserción de Leaflet porque ya no utilizo la API de Google para los mapas y anteriormente, en el link précédent, lo "llamamos" directamente de su sitio web-->
                                        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
                                        
                                        <script>
                                            
                                            function getLanguageFromURL() {
                                            const params = new URLSearchParams(window.location.search);
                                            return params.get('lang');
                                            }
                                            
                                            document.addEventListener("DOMContentLoaded", function() {
                                            const lang = getLanguageFromURL();
                                            if (lang === 'es') {
                                            switchLanguage('espanol');
                                            }
                                            if (lang === 'fr') {
                                            switchLanguage('francais');
                                            
                                            } else {
                                            switchLanguage('espanol');   /* Définit cette langue par défaut */
                                            }
                                            });
                                            function switchLanguage(lang) {
                                            document.querySelectorAll('.version').forEach(section => {
                                            section.style.display = 'none';
                                            });
                                            
                                            const selectedVersion = document.getElementById(lang);
                                            if (selectedVersion) {
                                            selectedVersion.style.display = 'block';
                                            }
                                            
                                            if (lang === 'espanol') {
                                            showSection('section-1');
                                            } else if (lang === 'francais') {
                                            showSection('section-fr-1');
                                            }
                                            }
                                            
                                            function showSection(sectionId) {
                                            document.querySelectorAll('.content-section').forEach(section => {
                                            section.style.display = 'none';  /* Cache toutes les sections */
                                            });
                                            
                                            const selectedSection = document.getElementById(sectionId);
                                            
                                            if (selectedSection) {
                                            selectedSection.style.display = 'block'; /* Affiche la section demandée */
                                            
                                            window.scrollTo({
                                            top: 0,                       /* Ramène la page en haut */
                                            behavior: 'smooth'            /* Ajoute une animation fluide */
                                            });}
                                            }
                                            
                                            function showNextSection(currentSectionId) {
                                            const sections = document.querySelectorAll('.conte-section');
                                            let nextSection = null;
                                            
                                            sections.forEach(section => {
                                            if (section.id === currentSectionId) {
                                            nextSection = section.nextElementSibling;
                                            section.style.display = 'none'; // ✅ corrigé
                                            }
                                            });
                                            
                                            if (nextSection) {
                                            nextSection.style.display = 'block';
                                            
                                            setTimeout(() => {
                                            const mainContent = document.querySelector('.version[style*="block"]');
                                            if (mainContent) {
                                            mainContent.scrollIntoView({
                                            behavior: 'smooth',
                                            block: 'start'
                                            });
                                            }
                                            }, 50);
                                            }
                                            }
                                            
                                            function showTraits(event, key) {
                                            event.preventDefault();
                                            
                                            document.querySelectorAll('.traits').forEach(trait => {
                                            trait.style.display = 'none';
                                            });
                                            
                                            const traits = document.getElementById(`traits-${key}`);
                                            if (traits) {
                                            traits.style.display = 'block';
                                            }
                                            
                                            highlightElements(key);
                                            }
                                            
                                            function highlightElements(key) {
                                            document.querySelectorAll('.highlight').forEach(el => {
                                            el.classList.remove('highlight');
                                            });
                                            
                                            document.querySelectorAll(`[data-key="${key}"]`).forEach(el => {
                                            el.classList.add('highlight');
                                            });
                                            }
                                            
                                            let map;
                                            let marker;
                                            
                                            function initMap() {
                                            map = L.map('map-container').setView([6.6437, -73.6532], 6);
                                            
                                            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                                            attribution: '© OpenStreetMap contributors'
                                            }).addTo(map);
                                            }
                                            
                                            function showMap(event, coords, placeName) {
                                            event.preventDefault();
                                            document.getElementById('map-modal').style.display = 'block';
                                            
                                            setTimeout(() => {
                                            map.invalidateSize();
                                            }, 200);
                                            
                                            if (!coords || coords.trim() === '') {
                                            alert("Lugar no indicado. Lieu non précisé.");
                                            return;
                                            }
                                            
                                            const [lat, lng] = coords.split(',').map(Number);
                                            
                                            map.setView([lat, lng], 8);
                                            
                                            if (marker) {
                                            map.removeLayer(marker);
                                            }
                                            
                                            marker = L.marker([lat, lng])
                                            .addTo(map)
                                            .bindPopup(`<strong>${placeName}</strong><br/>${getLocationDescription(placeName)}`)
                                                .openPopup();
                                                }
                                                
                                                function closeMap() {
                                                document.getElementById('map-modal').style.display = 'none';
                                                }
                                                
                                                document.addEventListener("DOMContentLoaded", initMap);
                                        </script>
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
                <div>
                    <button class="boutonaccess" onclick="document.body.classList.toggle('large-text')">
                        Cliquez ici pour agrandir le texte.
                    </button>
                </div>
                <div class="explicacion">
                    <p class="presentacion"><i>Luz y sombra</i> es un cuento del siglo XIX escrito por Soledad Acosta de Samper. Fue publicado en la prensa en tres publicaciones, llamadas en la época « entregas ».</p>
                    <p class="presentation"><i>La Lumière et l'Ombre</i> est un conte du XIXe siècle écrit par Soledad Acosta de Samper. Il a été publié dans la presse en trois parutions, appelées à l'époque « livraisons ».</p>
                </div>
                <div class="language-selector">
                    
                    <button onclick="switchLanguage('espanol')">Leer en español</button>
                    <button onclick="switchLanguage('francais')">Lire en français</button></div>
                
                <!-- ESPAÑOL Seccion in spanishhhh -->
                <div id="espanol" class="version" style="display: none;">
                    
                    <nav class="side-menu">
                        <button onclick="showSection('personnages-espanol')">Personajes</button>
                        <button onclick="showSection('lieux-espanol')">Lugares</button>
                        <button onclick="showSection('organisations-espanol')">Grupo de personas</button>
                        <button onclick="showSection('contexto-historico-espanol')">Otra categoría</button>
                        
                    </nav>
                    
                    <!-- ESPAÑOL Section personnajes (espagnol) -->
                    <div id="personnages-espanol" class="content-section">
                        <ul>
                            <xsl:for-each select="$luzisombra//tei:persName[generate-id() = generate-id(key('persNameByKey', @key)[1])]">
                                <li>
                                    <a href="#" onclick="showTraits(event, '{@key}')">
                                        <xsl:value-of select="."/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    
                    <!-- ESPAÑOL LUGARES ) -->
                    <div id="lieux-espanol" class="content-section">
                        <ul>
                            <xsl:for-each select="$luzisombra//tei:placeName[generate-id() = generate-id(key('placeNameByKey', @key)[1])]">
                                <li>
                                    <xsl:variable name="geoId" select="substring-after(@corresp, '#')"/>
                                    <xsl:variable name="coords" select="$luzisombra//tei:geo[@xml:id = $geoId]"/>
                                    <a href="#" onclick="showMap(event, '{$coords}', '{.}')">
                                        <xsl:value-of select="."/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    
                    <!-- ESPAÑOL ORGNAME -->
                    <div id="organisations-espanol" class="content-section">
                        <ul>
                            <xsl:for-each select="$luzisombra//tei:orgName[generate-id() = generate-id(key('orgNameByKey', @key)[1])]">
                                <li>
                                    <a href="#" onclick="showTraits(event, '{@key}')">
                                        <xsl:value-of select="."/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    
                    <!-- CONTEXTO HISTÓRICO -->
                    <div id="contexto-historico-espanol" class="content-section">
                        <h2>Otra categoría</h2>
                        <ul>
                            <!-- Afficher les segments de type "contextoHistorico" -->
                            <xsl:for-each select="$luzisombra//tei:seg[@type = 'contextoHistorico']">
                                <li>
                                    <xsl:value-of select="."/>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    
                    <!-- MOSTRAR el cuento por PUBLICACION -->
                    <xsl:for-each select="$luzisombra//tei:div[@type=('primera_publicacion','segunda_publicacion','tercera_publicacion')]">
                        <div id="section-{position()}" class="conte-section">
                            <xsl:apply-templates select="node() except tei:signed"/>
                                                        <button onclick="showNextSection('section-{position()}')">
                                <i><xsl:value-of select="@rend"/></i>
                            </button>
                            <xsl:apply-templates select="tei:signed"/>
                        </div>
                    </xsl:for-each>
                </div>
                   
                <!-- Version française -->
                <div id="francais" class="version">
                    
                    <nav class="side-menu">
                        <button onclick="showSection('personnages-francais')">Personnages</button>
                        <button onclick="showSection('lieux-francais')">Lieux</button>
                        <button onclick="showSection('organisations-francais')">Groupes de personnes</button>
                        <button onclick="showSection('contexte-historique-francais')">Une autre catégorie</button>
                        
                    </nav>
                    
                    <!-- Section personnages  -->
                    <div id="personnages-francais" class="content-section">
                        <ul>
                            <xsl:for-each select="$lalumiereetlombre//tei:persName[generate-id() = generate-id(key('persNameByKey', @key)[1])]">
                                <li>
                                    <a href="#" onclick="showTraits(event, '{@key}')">
                                        <xsl:value-of select="."/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    
                    <!-- Section lieux  -->
                    <div id="lieux-francais" class="content-section">
                        <ul>
                            <xsl:for-each select="$lalumiereetlombre//tei:placeName[generate-id() = generate-id(key('placeNameByKey', @key)[1])]">
                                <li>
                                    <xsl:variable name="geoId" select="substring-after(@corresp, '#')"/>
                                    <xsl:variable name="coords" select="$lalumiereetlombre//tei:geo[@xml:id = $geoId]"/>
                                    <a href="#" onclick="showMap(event, '{$coords}', '{.}')">
                                        <xsl:value-of select="."/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    
                    <!-- Section ORGNAME (français) -->
                    <div id="organisations-francais" class="content-section hidden">
                        <ul>
                            <xsl:for-each select="$lalumiereetlombre//tei:orgName[generate-id() = generate-id(key('orgNameByKey', @key)[1])]">
                                <li>
                                    <a href="#" onclick="showTraits(event, '{@key}')">
                                        <xsl:value-of select="."/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </div>
                    
                    
                    
                    
                    
                    <!-- Affichage du conte en sections -->
                    <xsl:for-each select="$lalumiereetlombre//tei:div[@type=('premiere_livraison','deuxieme_livraison','troisieme_livraison')]">
                        <div id="section-fr-{position()}" class="conte-section">
                            <!-- Excluir signed durante el procesamiento inicial -->
                            <xsl:apply-templates select="node() except tei:signed"/>
                            
                            <!-- Botón usando @rend del XML -->
                            <button onclick="showNextSection('section-fr-{position()}')">
                                <i><xsl:value-of select="@rend"/></i>
                            </button>
                            
                            <!-- Añadir signed después del botón -->
                            <xsl:apply-templates select="tei:signed"/>
                        </div>
                    </xsl:for-each>
                </div>
                
                <!-- Para integración del mapa -->
                <div id="map-modal" class="map-modal">
                    <span class="map-close" onclick="closeMap()">×</span>
                    <div id="map-container"></div>
                </div>
                
                <footer class="foot">
                    <p class="footer-texto">
                        Édition numérique créée par Yury Nataly Garzón Díaz.
                    </p>
                    
                    <div class="footer-logos">
                        <img src="rouen.jpg" alt="logo université de Rouen"/>
                            <img src="normandie1.jpg" alt="logo Normandie"/>
                    </div>
                </footer>
                
            </body>
        </html>
    </xsl:template>
    
    <!-- Template pour les paragraphes -->
    <xsl:template match="tei:p">
        <div class="paragraphe">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- Template pour la signature -->
    <xsl:template match="tei:signed">
        <div class="signature" id="signature-{generate-id()}">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
        
    <!-- Template pour les personnages --> 
    <xsl:template match="tei:persName">
        <span data-key="{@key}" class="persName">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Template pour les lieux-->
    <xsl:template match="tei:placeName">
        <span data-key="{@key}" class="placeName">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Template pour les orgName -->
    <xsl:template match="tei:orgName">
        <span data-key="{@key}" class="orgName">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- Template pour les <l> al principio del cuento que están dentro de <head> Primero hay que decirle que "reconozca el <head> para luego decirle que vaya hasta las <l> de adentro del <head> haha c'est fou-->
    <xsl:template match="tei:head">
        <div class="head">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
     <!-- Template pour les <l> de titulo del cuento :D le apliqué una prioridad porque antes había balisado como <"tei:head/l"> y no funcionaba, entonces busqué esa solución, pero el problema era que no le estaba diciendo en dónde se encontraban las <l>, et voilà, il fallait lui dire qu'ils étaient dans le... TEI !!!! :D la logique...-->
    <xsl:template match="tei:head/tei:l" priority="1">
        <div class="ltitulo">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Template pour les <l> de dialogo -->
    <xsl:template match="tei:l">
        <div class="ldialogo">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:geo">
    </xsl:template>
    
    
    <xsl:template match="tei:hi[@rend='italique']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    
    <xsl:template match="tei:choice">
        <xsl:apply-templates select="tei:reg"/>
    </xsl:template>
    
</xsl:stylesheet>