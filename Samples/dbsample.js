<script>
  alert('merhaba dünyaa');
  var serkan = {"aaa": "merhaba serkan güneþ", "bbb": {"ccc": "hhhhhh"}};
  hasan = "naber";
</script>

<script type="text/pascal">
  import serkan;
  import hasan;
  self.caption := serkan.GetValue('aaa') + ' -- ' + hasan;
  
  var AEl: THTMLElement;
  AEl := document.CreateElement('div');
 // AEl.SetAttribute('style', 'background-color: red;width:600px;height:500px');
  document.body.AppendElement(AEl);
  
  
  var c: TDBConnection;
  c:= TDBConnection.Create();
  c.ProviderName := 'MySql';
  c.Server := 'localhost';
  c.Database := 'folsecdb';
  c.Port := 3303;
  c.UserName := 'root';
  c.Password := 'FolSec1453';
  c.Open();
  
  var q: TDBQuery;
  var s: string;
  q:= TDBQuery.Create();
  q.Connection := c;
  q.SQL.Text := 'select * from shared_folders';
  q.Open();
  while not q.Eof do
  begin
     s := s + q.FieldByNameAsString('full_path') + ' <br> ';
     q.Next();
  end;
  AEl.InnerHtml :=  s;
  q.Close();
  q.Free();
  c.Close();
  c.Free();
  
    

</script>