<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="3.0">
    
    <!-- Format de sortie HTML -->
    <xsl:output method="html" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
    
    <!-- Pour le chhargement des documents -->
    <xsl:variable name="documentEspagnol" select="doc('esp_luz_i_sombra.xml')"/>
    <xsl:variable name="documentFrancais" select="doc('fr_lalumiere_et_lombre.xml')"/>
    
    <xsl:variable name="notes-traduction">
        <notes>
            <!-- template para las notitas en forma de infobulle :D -->
            <note id="p1" auteur="GARZÓN DÍAZ, Y. Nataly 2025">
                Des questions sur le choix de traduction par rapport au mot "gozo" se sont posées. Des mots synonymes comme "plaisir" et "goût" ont servi de pont pour aller analyser d'autres possibilités : joie, satifaction, gaité, contentement, bonheur, bien-être...
            </note>
            <note id="p2" auteur="1. et 2. GARZÓN DÍAZ, Y. Nataly 2025">
                1. le mot « acontecimiento » a suscité une réflexion sémantique. Il existe bien en espagnol le mot « evento », mais l’usage du mot acontecimiento donne à comprendre un événement d’une certaine gravité ou portée. En français, le terme « événement » s’est finalement imposé, même s’il est moins marqué.
                2. Le verbe « procurar » a également nécessité un classement de ses équivalents français selon leur intensité : « veiller à », « aspirer à », « chercher à », « viser à », « essayer de ».
            </note>
            <note id="p4" auteur="GARZÓN DÍAZ, Y. Nataly 2025">
                Le mot "hacienda" a été conservé dans la langue d'origine car il appartient au champ culturel intraduisible. Une hacienda, c'est une exploitation agricole et également, elle peut-être une ferme, ou l'inverse, ou les deux choses, ou une grande propriété, un terrain, qui n'est pas forcément exploitée ou travaillée peut-être une hacienda aussi.
            </note>    
            <note id="p6" auteur="GARZÓN DÍAZ, Y. Nataly 2025">
                "Ya lánguida, ya viva > Au début, traduit comme "soit... soit..." mais par le registre de langue, on a préféré la tournure "tantôt..., tantôt..."
            </note>
            
            
        </notes>
    </xsl:variable>
    
    <xsl:template match="/">
        <html lang="fr">
            <head>
                <meta charset="UTF-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                <title>Version comparée : espagnol et français</title>
                <link rel="stylesheet" href="style.css"/>
            
                <script type="text/javascript">
                    function toggleVersion() {
                    const espCols = document.querySelectorAll('.colonne-source');
                    
                    espCols.forEach(col => {
                    col.classList.toggle('show-reg');
                    });
                    
                    const btn = document.getElementById('btnToggle');
                    
                    const isReg = espCols[0].classList.contains('show-reg');
                    
                    btn.textContent = isReg
                    ? 'Afficher version originale'
                    : 'Afficher version modernisée';
                    }
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
                
                <div class="titulo">
                    <h1>Version bilingue comparada</h1>
                    <h2>Version bilingue comparée</h2>                   
                    
                </div>
                
                <div class="explicacion">
                    <p class="presentacion">Aquí encontrarán las versiones en español y en francés del texto, alineadas por párrafo, destinada a las personas que se interesan en las diferencias linguísticas y/o los análisis traductológicos.</p>
                    <p class="presentation">Ici, vous trouverez les versions espagnole et française du texte, alignées par paragraphes, destinée aux personnes s'intéressant aux différences linguistiques et/ou aux analyses traductologiques.</p>
                </div>
                
                <table class="table-traduction">
                                     
                    <thead>
                        <tr>
                            <th class="langue-source">Luz i sombra</th>
                            <th class="langue-cible">La lumière et l'ombre</th>
                        </tr>
                        <tr>
                            <th>
                                <button id="btnToggle" onclick="toggleVersion()" class="btn-bascule">
                                    Version modernisée
                                </button>
                            </th>
                        </tr> 
                           </thead>
                    
                    <tbody>
                       <xsl:for-each select="$documentEspagnol//tei:p[@xml:id]">
                            <xsl:variable name="idParagraphe" select="@xml:id"/>
                            <xsl:variable name="paragrapheFrancais" 
                                select="$documentFrancais//tei:p[@xml:id = $idParagraphe]"/>
                            
                            <!-- Ligne avec id de chaque paragraphe pour mieux suivre la traduction -->
                            <tr class="ligne-paragraphe" id="{$idParagraphe}">
                                
                                <!-- Colonne espagnole incluye también la numeración de párrafos automática -->
                                <td class="colonne-source">
                                    <div class="en-tete-paragraphe">
                                        <span class="numero-paragraphe">¶<xsl:value-of select="position()"/></span>
                                        <span class="indicateur-langue">español</span>
                                    </div>
                                    <div class="contenu-texte">
                                        <xsl:apply-templates select="node()"/>
                                    </div>
                                </td>
                                
                                <!-- Colonne française -->
                                <td class="colonne-cible">
                                    <div class="en-tete-paragraphe">
                                        <span class="numero-paragraphe">¶<xsl:value-of select="position()"/></span>
                                        <span class="indicateur-langue">français</span>
                                    </div>
                                    <div class="contenu-texte">
                                        <xsl:apply-templates select="$paragrapheFrancais/node()"/>
                                    
                                        <!-- Afficher la note si elle existe pour ce paragraphe -->
                                        <xsl:if test="$notes-traduction//note[@id = current()/@xml:id]">
                                            <sup class="note-icon" 
                                                title="{$notes-traduction//note[@id = current()/@xml:id]} (Source: {$notes-traduction//note[@id = current()/@xml:id]/@auteur})">
                                                &#x1F4D6;
                                            </sup>
                                        </xsl:if>
                                    
                                    </div>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
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
    
    <!-- Autres templates -->
    <xsl:template match="tei:*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- Copie standard du contenu -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:geo">
    </xsl:template>
    
    <!-- Templates para orig y reg -->
    <xsl:template match="tei:choice">
        <span class="variante">
            <span class="orig"><xsl:apply-templates select="tei:orig"/></span>
            <span class="reg"><xsl:apply-templates select="tei:reg"/></span>
        </span>
    </xsl:template>
</xsl:stylesheet>