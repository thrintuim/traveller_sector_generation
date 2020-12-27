<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" />
    <xsl:variable name="hexHalfHeight">
        <xsl:value-of select="number(43.3012)" />
    </xsl:variable>
    <xsl:variable name="hexHeight">
        <xsl:value-of select="number(86.6024)" />
    </xsl:variable>
    <xsl:variable name="columnWidth">
        <xsl:value-of select="number(75)" />
    </xsl:variable>
    <xsl:template match="subsector">
        <xsl:variable select="@title" name="subsectorTitle" />
        <html>

        <head>
            <style>
            .coord {
                font-size: 10px;
            }

            text {
                font-size: 12px;
            }

            .world {
                stroke: black;
                stroke-width: 2px;
            }

            .gasGiant {
                stroke: black;
                stroke-width: 1px;
            }

            .base {
                font-size: 16px;
            }
            .name {
                font-size: 14px;
            }
            .inline {
                display: inline;
                vertical-align: top;
            }
            </style>
            <style id="trade">
            .trade1 {
                stroke-width: 1;
                stroke: #000;
            }

            .trade2 {
                stroke-width: 2;
                stroke: #000;
            }
            </style>
            <script src="tradeSelection.js"><xsl:text> </xsl:text></script>
        </head>

        <body>
            <div class="inline">
                <svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 625 952.626" width="625" height="952.626">
                    <title>
                        <xsl:value-of select="$subsectorTitle" />
                    </title>
                    <defs>
                        <polygon id="hex" points="-50,0 -25,-43.3012 25,-43.3012 50,0 25,43.3012 -25,43.3012" fill="rgba(0,0,0,0)" stroke="black" stroke-width="0.5" />
                        <circle id="dryWorld" cx="0" cy="0" r="6" class="world" fill="none" />
                        <circle id="wetWorld" cx="0" cy="0" r="6" fill="blue" class="world" />
                        <circle id="gasGiant" cx="0" cy="0" r="4" class="gasGiant" fill="yellow" stroke-width="1px" />
                        <polygon points="-5,5 0,-5 5,5" fill="black" id="scoutBase" />
                        <text id="navalBase" x="0" y="0" class="base" text-anchor="middle">*</text>
                        <marker id="arrowhead" viewBox="0 0 10 10" refX="1" refY="5" markerWidth="6" markerHeight="6" orient="auto">
                            <path d="M 0 0 L 10 5 L 0 10 z" />
                        </marker>
                    </defs>
                    <xsl:apply-templates />
                </svg>
            </div>
            <div class="inline">
                <label>Source World: <select id="source">
                    <option value="All">All</option>
                    <option value="None">None</option>
                    <xsl:for-each select="hex[contents]">
                        <xsl:element name="option">
                            <xsl:attribute name="value"><xsl:value-of select="@hexid" /></xsl:attribute>
                            <xsl:value-of select="@hexid" />
                        </xsl:element>
                    </xsl:for-each>
                </select></label>
                <label>Target World: <select id="target">
                    <option value="All">All</option>
                    <option value="None">None</option>
                    <xsl:for-each select="hex[contents]">
                        <xsl:element name="option">
                            <xsl:attribute name="value"><xsl:value-of select="@hexid" /></xsl:attribute>
                            <xsl:value-of select="@hexid" />
                        </xsl:element>
                    </xsl:for-each>
                </select></label>
            </div>
        </body>

        </html>
    </xsl:template>
    <xsl:template match="hex">
        <xsl:variable name="hexNumber" select="@hexid" />
        <xsl:element name="g" namespace="{'http://www.w3.org/2000/svg'}">
            <xsl:element name="title" namespace="{'http://www.w3.org/2000/svg'}">
                <xsl:for-each select=".//world">
                    <xsl:variable name="currentWorld" select="." />
                    <xsl:text> World: </xsl:text>
                    <xsl:value-of select="@name" />
                    <xsl:text>
                        UPP: </xsl:text>
                    <xsl:value-of select="@upp" />
                    <xsl:text>
                        Tech: </xsl:text>
                    <xsl:value-of select="@tech" />
                    <xsl:text>
                        Trade Classifications: </xsl:text>
                    <xsl:value-of select="normalize-space(.//tradeClassifications/tradeNotes)" />
                    <xsl:text>
                        Notes: </xsl:text>
                    <xsl:value-of select="normalize-space(.//notes)" />
                    <xsl:text>
                        Trade:
                    </xsl:text>
                    <xsl:for-each select="/subsector/hex[@hexid != $hexNumber]//world">
                        <xsl:variable name="tradeStuff">
                            <xsl:call-template name="determineTradeBenefits">
                                <xsl:with-param name="sw" select="$currentWorld" />
                                <xsl:with-param name="tw" select="." />
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:variable name="world_name">
                            <xsl:choose>
                                <xsl:when test="@name=''"><xsl:value-of select="ancestor::hex/@hexid" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="@name" /></xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$tradeStuff &gt; 0">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="$world_name" />
                            <xsl:text>: </xsl:text>
                            <xsl:value-of select="$tradeStuff" />
                            <xsl:text>
                            </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:element>
            <xsl:variable name="columnNumber" select="substring($hexNumber,2,1)" />
            <xsl:variable name="hexRow" select="substring($hexNumber, 3, 2)" />
            <xsl:variable name="yValue">
                <xsl:call-template name="determineHexYPlacement">
                    <xsl:with-param name="hexRow" select="$hexRow" />
                    <xsl:with-param name="columnNumber" select="$columnNumber" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="xValue">
                <xsl:call-template name="determineHexXPlacement">
                    <xsl:with-param name="columnNumber" select="$columnNumber" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:element name="use" namespace="{'http://www.w3.org/2000/svg'}">
                <xsl:attribute name="x">
                    <xsl:value-of select="$xValue" />
                </xsl:attribute>
                <xsl:attribute name="y">
                    <xsl:value-of select="$yValue" />
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#hex</xsl:text>
                </xsl:attribute>
            </xsl:element>
            <xsl:apply-templates select="@hexid">
                <xsl:with-param name="hexXValue" select="$xValue" />
                <xsl:with-param name="hexYValue" select="$yValue" />
            </xsl:apply-templates>
            <xsl:if test=".//world">
                <xsl:call-template name="world">
                    <xsl:with-param name="worldEl" select=".//world[1]" />
                    <xsl:with-param name="hexXValue" select="$xValue" />
                    <xsl:with-param name="hexYValue" select="$yValue" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test=".//navalBase">
                <xsl:call-template name="navalBase">
                    <xsl:with-param name="hexXValue" select="$xValue" />
                    <xsl:with-param name="hexYValue" select="$yValue" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test=".//scoutBase">
                <xsl:call-template name="scoutBase">
                    <xsl:with-param name="hexXValue" select="$xValue" />
                    <xsl:with-param name="hexYValue" select="$yValue" />
                </xsl:call-template>
            </xsl:if>
            <xsl:if test=".//gasGiant">
                <xsl:call-template name="gasGiant">
                    <xsl:with-param name="hexXValue" select="$xValue" />
                    <xsl:with-param name="hexYValue" select="$yValue" />
                </xsl:call-template>
            </xsl:if>
        </xsl:element>
    </xsl:template>
    <xsl:template name="world">
        <xsl:param name="worldEl" />
        <xsl:param name="hexXValue" />
        <xsl:param name="hexYValue" />
        <xsl:variable name="hexNumber" select="$worldEl/ancestor::hex/@hexid" />
        <xsl:variable name="upp" select="$worldEl/@upp" />
        <xsl:variable name="starport" select="substring($upp, 1,1)" />
        <xsl:variable name="water" select="substring($upp, 4,1)" />
        <xsl:element name="use" namespace="{'http://www.w3.org/2000/svg'}">
            <xsl:attribute name="x">
                <xsl:value-of select="$hexXValue" />
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="$hexYValue" />
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="$water = 0">
                        <xsl:text>#dryWorld</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>#wetWorld</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </xsl:element>
        <xsl:element name="text" namespace="{'http://www.w3.org/2000/svg'}">
            <xsl:attribute name="x">
                <xsl:value-of select="number($hexXValue)" />
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="number($hexYValue - 10)" />
            </xsl:attribute>
            <xsl:attribute name="text-anchor">
                <xsl:text>middle</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="$starport" />
        </xsl:element>
        <xsl:element name="text" namespace="{'http://www.w3.org/2000/svg'}">
            <xsl:attribute name="x">
                <xsl:value-of select="number($hexXValue)" />
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="number($hexYValue + 35)" />
            </xsl:attribute>
            <xsl:attribute name="text-anchor">
                <xsl:text>middle</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="$worldEl/@name" />
        </xsl:element>
        <xsl:for-each select="/descendant::hex[@hexid != $hexNumber]//world">
            <xsl:variable name="tw" select="." />
            <xsl:variable name="tradeStuff">
                <xsl:call-template name="determineTradeBenefits">
                    <xsl:with-param name="sw" select="$worldEl" />
                    <xsl:with-param name="tw" select="$tw" />
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="$tradeStuff &gt; 0">
                <xsl:element name="line" namespace="{'http://www.w3.org/2000/svg'}">
                    <xsl:attribute name="x1">
                        <xsl:value-of select="number($hexXValue)" />
                    </xsl:attribute>
                    <xsl:attribute name="y1">
                        <xsl:value-of select="number($hexYValue)" />
                    </xsl:attribute>
                    <xsl:variable name="twhexNumber" select="$tw/ancestor::hex/@hexid" />
                    <xsl:variable name="columnNumber" select="substring($twhexNumber,2,1)" />
                    <xsl:variable name="hexRow" select="substring($twhexNumber, 3, 2)" />
                    <xsl:variable name="yValue">
                        <xsl:call-template name="determineHexYPlacement">
                            <xsl:with-param name="hexRow" select="$hexRow" />
                            <xsl:with-param name="columnNumber" select="$columnNumber" />
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:variable name="xValue">
                        <xsl:call-template name="determineHexXPlacement">
                            <xsl:with-param name="columnNumber" select="$columnNumber" />
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:attribute name="stroke">none</xsl:attribute>
                    <xsl:attribute name="stroke-width">0</xsl:attribute>
                    <xsl:attribute name="x2">
                        <xsl:value-of select="$xValue" />
                    </xsl:attribute>
                    <xsl:attribute name="y2">
                        <xsl:value-of select="$yValue" />
                    </xsl:attribute>
                    <xsl:attribute name="class">
                        <xsl:text>trade</xsl:text>
                        <xsl:value-of select="$tradeStuff" />
                    </xsl:attribute>
                    <xsl:attribute name="data-source">
                        <xsl:value-of select="$hexNumber" />
                    </xsl:attribute>
                    <xsl:attribute name="data-target">
                        <xsl:value-of select="$twhexNumber" />
                    </xsl:attribute>
                    <xsl:attribute name="marker-end">
                        <xsl:text>url(#arrowhead)</xsl:text>
                    </xsl:attribute>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="navalBase">
        <xsl:param name="hexXValue" />
        <xsl:param name="hexYValue" />
        <xsl:element name="use" namespace="{'http://www.w3.org/2000/svg'}">
            <xsl:attribute name="x">
                <xsl:value-of select="($hexXValue - 20)" />
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="($hexYValue - 10)" />
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#navalBase</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template name="scoutBase">
        <xsl:param name="hexXValue" />
        <xsl:param name="hexYValue" />
        <xsl:element name="use" namespace="{'http://www.w3.org/2000/svg'}">
            <xsl:attribute name="x">
                <xsl:value-of select="($hexXValue - 20)" />
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="($hexYValue + 10)" />
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#scoutBase</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template name="gasGiant">
        <xsl:param name="hexXValue" />
        <xsl:param name="hexYValue" />
        <xsl:element name="use" namespace="{'http://www.w3.org/2000/svg'}">
            <xsl:attribute name="x">
                <xsl:value-of select="($hexXValue + 20)" />
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="($hexYValue - 20)" />
            </xsl:attribute>
            <xsl:attribute name="href">
                <xsl:text>#gasGiant</xsl:text>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@hexid">
        <xsl:param name="hexXValue" />
        <xsl:param name="hexYValue" />
        <xsl:element name="text" namespace="{'http://www.w3.org/2000/svg'}">
            <xsl:attribute name="class">
                <xsl:text>coord</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="x">
                <xsl:value-of select="number($hexXValue)" />
            </xsl:attribute>
            <xsl:attribute name="y">
                <xsl:value-of select="number($hexYValue - 30)" />
            </xsl:attribute>
            <xsl:attribute name="text-anchor">
                <xsl:text>middle</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="." />
        </xsl:element>
    </xsl:template>
    <xsl:template name="determineHexXPlacement">
        <xsl:param name="columnNumber" />
        <xsl:value-of select="number((($columnNumber - 1) * $columnWidth) + 50)" />
    </xsl:template>
    <xsl:template name="determineHexYPlacement">
        <xsl:param name="hexRow" />
        <xsl:param name="columnNumber" />
        <xsl:choose>
            <xsl:when test="($columnNumber mod 2) = 0">
                <xsl:value-of select="number((($hexRow - 1) * $hexHeight) + $hexHeight)" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number((($hexRow - 1) * $hexHeight) + $hexHalfHeight)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="determineTradeBenefits">
        <xsl:param name="sw" />
        <xsl:param name="tw" />
        <xsl:variable name="AgCount">
            <xsl:call-template name="Ag">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="AsCount">
            <xsl:call-template name="As">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="BaCount">
            <xsl:call-template name="Ba">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="DeCount">
            <xsl:call-template name="De">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="FlCount">
            <xsl:call-template name="Fl">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="HiCount">
            <xsl:call-template name="Hi">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="IcCount">
            <xsl:call-template name="Ic">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="InCount">
            <xsl:call-template name="In">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="LoCount">
            <xsl:call-template name="Lo">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="NaCount">
            <xsl:call-template name="Na">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="NiCount">
            <xsl:call-template name="Ni">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="PoCount">
            <xsl:call-template name="Po">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="RiCount">
            <xsl:call-template name="Ri">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="VaCount">
            <xsl:call-template name="Va">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="WaCount">
            <xsl:call-template name="Wa">
                <xsl:with-param name="sourceWorld" select="$sw" />
                <xsl:with-param name="targetWorld" select="$tw" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$AgCount + $AsCount + $BaCount + $DeCount + $FlCount + $HiCount + $IcCount + $InCount + $LoCount + $NaCount + $NiCount + $PoCount + $RiCount + $VaCount + $WaCount" />
    </xsl:template>
    <xsl:template name="Ag">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Ag']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ag']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='As']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='De']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Hi']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Lo']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Na']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ri']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="As">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='As']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='As']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Na']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ri']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Va']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Ba">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Ba']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ag']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="De">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='De']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='De']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Na']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Fl">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Fl']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Fl']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Hi">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Hi']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Hi']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Lo']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ri']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Ic">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Ic']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="In">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='In']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ag']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='As']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='De']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Fl']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Hi']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ni']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Po']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ri']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Va']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Wa']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Lo">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Lo']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ri']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Na">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Na']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='As']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='De']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Va']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Ni">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Ni']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ni']">
                        <xsl:value-of select="number(-1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Po">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Po']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Po']">
                        <xsl:value-of select="number(-1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Ri">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Ri']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ag']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='De']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Hi']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Na']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ri']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Va">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Va']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='As']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Va']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="Wa">
        <xsl:param name="sourceWorld" />
        <xsl:param name="targetWorld" />
        <xsl:choose>
            <xsl:when test="$sourceWorld/tradeClassifications/class[.='Wa']">
                <xsl:choose>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='In']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Ri']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:when test="$targetWorld/tradeClassifications/class[.='Wa']">
                        <xsl:value-of select="number(1)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="number(0)" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(0)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="translateSize">
        <xsl:param name="size" />
        <xsl:choose>
            <xsl:when test="$size='0'">
                <xsl:text>Asteroid Belt</xsl:text>
            </xsl:when>
            <xsl:when test="$size='1'">
                <xsl:text>1000 miles</xsl:text>
            </xsl:when>
            <xsl:when test="$size='2'">
                <xsl:text>2000 miles</xsl:text>
            </xsl:when>
            <xsl:when test="$size='3'">
                <xsl:text>3000 miles</xsl:text>
            </xsl:when>
            <xsl:when test="$size='4'">
                <xsl:text>4000 miles</xsl:text>
            </xsl:when>
            <xsl:when test="$size='5'">
                <xsl:text>5000 miles</xsl:text>
            </xsl:when>
            <xsl:when test="$size='6'">
                <xsl:text>6000 miles</xsl:text>
            </xsl:when>
            <xsl:when test="$size='7'">
                <xsl:text>7000 miles</xsl:text>
            </xsl:when>
            <xsl:when test="$size='8'">
                <xsl:text>8000 miles</xsl:text>
            </xsl:when>
            <xsl:when test="$size='9'">
                <xsl:text>9000 miles</xsl:text>
            </xsl:when>
            <xsl:when test="$size='A'">
                <xsl:text>10000 miles</xsl:text>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>