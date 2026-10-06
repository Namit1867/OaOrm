#uses "DatabaseAdapter"
#uses "Models/Recipe"
#uses "Models/Step"
#uses "Models/StepInstance"

class AbstractMapper
{
  protected DatabaseAdapter sAdapter = DatabaseAdapter("","");
  protected string sTable;
  protected mapping sEntityClass;

  public AbstractMapper(DatabaseAdapter adapter = "")
  {
    sAdapter = adapter;

  }
  public void setEntityTable(string table)
  {
      sTable = table;
  }
  public mapping setEntityClass(string table)
  {


  }
  public int count(dyn_string where= "")
  {
    return sAdapter.count(sTable,where);
  }
  public dyn_anytype find(string fields = "*", dyn_string where= "" , string order = "")
  {
    dyn_anytype m;
    dyn_dyn_anytype entities = sAdapter.select(fields,sTable,where);
   // DebugN("Entities "+entities);
    m = createEntity(entities);
    return m;
  }
  public void deleteEntity(int id, string col)
  {
    DebugN("table " +  sTable +"  "+ col + " " + id);
    sAdapter.deleteEntity(sTable,col + " = "+ id);
  }
  public void deleteGroup(string id, string col)
  {
     sAdapter.deleteEntity(sTable,col + " = '"+ id+"'");
  }
  public void insert(string entity,bool ignoreKey = true)
  {
      sAdapter.insert(sTable,entity,ignoreKey);
  }
  public void update(string entity,dyn_string where)
  {
      sAdapter.update(sTable,entity,where);
  }
  public dyn_anytype createEntity(dyn_dyn_anytype entities) {dyn_anytype d; return d;  }
  public void query(string query){ sAdapter.query(query);}
  public dyn_dyn_anytype selectQuery(string query){return sAdapter.selectQuery(query);}
};



    string tablesQuery = " SELECT TABLE_NAME" +
    " FROM INFORMATION_SCHEMA.TABLES"+
    " WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG='"+dbName+"'";
    DebugN(tablesQuery);
    dyn_dyn_anytype tablesResult = rdbOpenSelectClose(tablesQuery);
   // DebugN(tablesResult);
    for(int i = 1; i <= dynlen(tablesResult); i++)
    {
        string table = tablesResult[i][1];
        getTableInfo(table);
    }
  }
  void getTableInfo(string table)
  {
    ModelFactory model = ModelFactory(table);
    MapperFactory mapper = MapperFactory(table);

    string columnsQuery = "SELECT COLUMN_NAME, DATA_TYPE"+
    " FROM INFORMATION_SCHEMA.COLUMNS"+
    " WHERE table_name = '"+table+"'";
    dyn_dyn_anytype columnsResult = rdbOpenSelectClose(columnsQuery);
   // DebugN(tablesResult);
    for(int i = 1; i <= dynlen(columnsResult); i++)
    {
        string columnName = columnsResult[i][1];
        string columnDataType = determineDataType(columnsResult[i][2]);
        model.addProperty(columnName,columnDataType);
        mapper.addProperty(columnName,i);
        //string line = "public "+columnDataType+" "+columnName+";\n";
    }
    model.finishModel();
    mapper.finishMapper();
    DebugN(model.getModelString());
    writeFile(model.getModelString(),"Models\\"+table);
    writeFile(mapper.getMapperString(),"Mappers\\"+table+"Mapper");
  }
  string determineDataType(string dbDataType)
  {
    switch(dbDataType)
    {
      case "int": return "int";
      case "nvarchar": return "string";
      case "datetime": return "string";
      case "bit": return "bool";
    }
  }
  void writeFile(string content,string fileName)
  {
     file f; // our file
     int err; // error code
     string fileString = "C:\\WinCC_OA_Proj\\OaOrm\\scripts\\libs\\"+fileName+".ctl";
     f = fopen(fileString, "wb+"); //Open a binary file for writing and reading