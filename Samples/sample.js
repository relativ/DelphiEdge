<a href="javascript:void(0);" id="testid">týkla</a>
<div id="holder">
holder
</div>
<div id="delphifunction">
</div>

<script>
  var serkan = {"aaa": "merhaba serkan güneþ", "bbb": {"ccc": "hhhhhh"}};
  hasan = "naber";
  
  function callFunc(test, test2) {
	var obj = {};
	obj.merhaba = {};
	obj.merhaba.aloo  = test + '--->'+ test2;
	return obj;
  }
  window.onload = function(e) {
	document.getElementById('delphifunction').innerHTML = window.external.run('deneme', {"deger":"merhaba deðer"});
  }
</script>


<script type="text/pascal">
  import serkan;
  import hasan;
  self.caption := serkan.GetObject('bbb').GetValue('ccc') + ' -- ' + hasan;
  var scall : Variant;
  scall := window.call('callFunc', ['merhaba', 'deneme']);
  var js: TJSObject;
  js := JSDecode(scall);
  showmessage(js.GetObject('merhaba').GetValue('aloo'));
  
  var element: THTMLElement;
  element := document.CreateElement('a');
  element.setAttribute('href', 'http://www.sahibinden.com');
  element.InnerText := 'sahibinden.com';
  document.body.AppendElement(element);
  showmessage('ddddd');
  showmessage(window.location.href);
  //window.location.href = 'http://www.haberturk.com';
  showmessage(inttostr(window.screen.width));
  
 
  procedure fetchdb;
	var 
		c: TDBConnection;
		q: TDBQuery;
		s: string;
		AEl: THTMLElement;
  begin
    c:= TDBConnection.Create();
    c.ProviderName := 'MySql';
    c.Server := 'localhost';
    c.Database := 'folsecdb';
    c.Port := 3303;
    c.UserName := 'root';
    c.Password := 'FolSec1453';
    c.Params.Values['CharacterSet'] := 'utf8';
    c.Open();
  
  
    q:= TDBQuery.Create();
    q.Connection := c;
    q.SQL.Text := 'select * from shared_folders';
    q.Open();
    while not q.Eof do
    begin
     s := s + q.FieldByNameAsString('folder_name') + ' <br> ';
     q.Next();
    end;
   
    AEl := document.getElementById('holder');
    AEl.InnerHtml :=  s;
    q.Close();
    q.Free();
    c.Close();
    c.Free();
  end;
  
  document.GetElementById('testid').AttachEvent('onclick', 'fetchdb');
  

function deneme(val: variant): variant;
var
   jsobj: TJSObject;
begin
     showmessage('ddddd');
     jsobj := JSDecode(val);
     result := jsobj.GetValue('deger') + '<---';
end;

var s: string;
var j : TJSON;
s := '{"merhaba": "degerin", "aloo": {"ne": "var"}}';
j := TJSON.Create();
j:= j.parse(s);

showmessage(j['merhaba'].AsString);
showmessage(j['aloo']['ne'].AsString);

</script>

