#uses "Mappers/MissionMapper"
//Declare a DatabaseAdapter instance to work with
//Pass the ODBC connection string and the Database name to the adapter
DatabaseAdapter db = DatabaseAdapter("DSN=mydb;UID=sa;PWD=***;","SixtyKPressSCADA");

//Declare a Mapper, this mapper will correspond with the table you want to work with
MissionMapper mMapper;
//Simple function I'm calling from the panel on a button click
buttonClick()
{
  //Initialize the mapper with the DatabaseAdapter instance and the table to work with
  mMapper.init(db,"Mission");

  //These are functions to test everything
 // DebugN(GetAllThings());
 // DebugN(GetOneThing());
 // UpdateOneThing();

}
//This function will get all records in the table
public dyn_anytype GetAllThings()
{
  //Declare a dyn_anytype to hold our objects
  dyn_anytype things;
  //Assign the results to the variable we created.  These variables can then be cast to a concrete instance
  things = mMapper.find("*");