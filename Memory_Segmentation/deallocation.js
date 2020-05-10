
/*function struct ( type : "",
                 id: "",
                 processName: "",
                 state: "",
                 algorithmType: "",
                 base:100,
                 size:100
                 )
{
    this.type : type;
    this.id : id;
    this.processName : processName;
    this.state : state;
    this.algorithmType:algorithmType;
    this.base:base;
    this.limit:limit;

}*/



var memList = [];
var struct = {
    Type : "hole", // hole,restricted,segment
    id : "hole1", //hole+i,rest+i,p+i
    segmentName : "", //any valid name
    state: "", //new, pending
    algorithmType: "",//firstfit,bestfit
    base:0,//int
    size:10//int
};
memList.push(struct);

var struct = {
    Type : "restricted",
    id: "rest1",
    segmentName: "",
    state: "",
    algorithmType: "",
    base:10,
    size:10
};
memList.push(struct);

struct = {
    Type : "hole",
    id: "hole2",
    segmentName: "",
    state: "",
    algorithmType: "",
    base:20,
    size:5
};
memList.push(struct);

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg1",
    state: "new",
    algorithmType: "ff",
    base:25,
    size:5
};
memList.push(struct);

struct = {
    Type : "segment",
    id: "p2",
    segmentName: "seg1",
    state: "new",
    algorithmType: "ff",
    base:30,
    size:10
};
memList.push(struct);

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg2",
    state: "new",
    algorithmType: "ff",
    base:40,
    size:10
};
memList.push(struct);

struct = {
    Type : "hole",
    id: "hole3",
    segmentName: "",
    state: "",
    algorithmType: "",
    base:50,
    size:5
};
memList.push(struct);

struct = {
    Type : "restricted",
    id: "rest2",
    segmentName: "",
    state: "",
    algorithmType: "",
    base:55,
    size:15
};
memList.push(struct);

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg3",
    state: "new",
    algorithmType: "ff",
    base:70,
    size:30
};
memList.push(struct);
print();

function deallocate( name) {
    console.log(name)
    for(  var i = 0 ; i < memList.length ; i++)
    {
        if(memList[i].id === name)
        {
            memList[i].Type = "hole";
            //memList[i].id = "hole".concat(num.toString()); // concat("hole,listOfHoles.length)
            memList[i].processName= "";
            memList[i].state= "";
            memList[i].algorithmType= "";
        }
    }

    merge()
    //checkValidity(pendingList[0])
    print()
};

function merge()
{
    var num = 1

    for( var i =  memList.length-1 ; i > 0; i--)
    {
        if(memList[i].Type==="hole" && memList[i-1].Type==="hole")
        {
            memList[i-1].size += memList[i].size
            memList.splice(i,1)
        }
    }
    for(  i = 0 ; i <  memList.length; i++){if(memList[i].Type==="hole" ){
            memList[i].id = "hole".concat((num++).toString())}}

}

function print() {

    for(  var i = 0 ; i < memList.length ; i++)
    {console.log("id: "+memList[i].id+" base: "+memList[i].base+" size: "+memList[i].size)}
    console.log("____________")
}

