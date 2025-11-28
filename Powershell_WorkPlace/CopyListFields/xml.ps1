$xml = @'
<xml>
<compilation defaultLanguage="c#" debug="true" targetframework="4.0" testV="1" testV1="test"></compilation>
</xml>
'@ -as [xml]

$xml.Attributes

$node = $xml.selectSingleNode('//compilation')

$node.RemoveAttribute('debug')
$node.RemoveAttribute('targetframework')
$node.testV="2"


$node.Attributes |ForEach-Object {
    'Name: {0}; Value: {1}' -f $_.LocalName,$_.Value
}

$ui =$node.Attributes | Where-Object {$_.LocalName  -like "testV*" } | Select-Object $_.LocalName
$ui[0].Name

$xml.OuterXml

foreach($uiE in $ui){
    $node.RemoveAttribute($uiE.Name)

}