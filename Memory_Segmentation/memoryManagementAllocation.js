var memList = [];
let listOfHoles = [];
var memorySize = 100
let listOfSegments= [];
let tempHoleList = [] ;
var pendingList = [] ;


/******************************************************************/

/************************************************************************************/

//struct = {
//    Type : "segment",
//    id: "p1",
//    segmentName: "seg1",
//    state: "new",
//    algorithmType: "bestfit",
//    base:-1,
//    size:2
//};
//listOfSegments.push(struct);

//struct = {
//    Type : "segment",
//    id: "p1",
//    segmentName: "seg2",
//    state: "new",
//    algorithmType: "bestfit",
//    base:-1,
//    size:16
//};
//listOfSegments.push(struct);

//struct = {
//    Type : "segment",
//    id: "p1",
//    segmentName: "seg3",
//    state: "new",
//    algorithmType: "bestfit",
//    base:-1,
//    size:20
//};
//listOfSegments.push(struct);

//struct = {
//    Type : "segment",
//    id: "p1",
//    segmentName: "seg4",
//    state: "new",
//    algorithmType: "bestfit",
//    base:70,
//    size:45
//};
//listOfSegments.push(struct);


///********************************************/


//var struct = {
//    Type : "hole", // hole,restricted,segment
//    id : "hole1", //hole+i,rest+i,p+i
//    segmentName : "", //any valid name
//    state: "", //new, pending
//    algorithmType: "",//firstfit,bestfit
//    base:10,//int
//    size:18//int
//};

//listOfHoles.push(struct);
//tempHoleList.push(struct);

//struct = {
//    Type : "hole",
//    id: "hole2",
//    segmentName: "",
//    state: "",
//    algorithmType: "",
//    base:30,
//    size:9
//};

//listOfHoles.push(struct);
//tempHoleList.push(struct);

//struct = {
//    Type : "hole",
//    id: "hole3",
//    segmentName: "",
//    state: "",
//    algorithmType: "",
//    base:50,
//    size:30
//};

//listOfHoles.push(struct);
//tempHoleList.push(struct);

//var struct = {
//    Type : "hole", // hole,restricted,segment
//    id : "hole4", //hole+i,rest+i,p+i
//    segmentName : "", //any valid name
//    state: "", //new, pending
//    algorithmType: "",//firstfit,bestfit
//    base:80,//int
//    size:20//int
//};

//listOfHoles.push(struct);


//tempHoleList.push(struct);

/* Implmementation of memory initialization-list by pushing to the global list
 * specific number of holes & restricted areas to fill the memory
*/

/**************************** initializeMemory Function ******************************/
function initializeMemory(listOfHoles_temp)
{
    listOfHoles = listOfHoles_temp
    mergeListOfHoles ();
    var currentMemoryLocation=0,holeCounter=0,restCounter=1;

    // Sorting holes based on base address
    listOfHoles.sort(function(a,b){
        return a.base - b.base;
    });

    // Looping over the number of holes to fill onto the memory
    while(holeCounter < listOfHoles.length){

        // if the base of a hole is bigger than the currentMemoryLocation
        // we insert a new restritcted area to fit into the memory till the next hole
        if(listOfHoles[holeCounter].base > currentMemoryLocation)
        {
            var TempRestrictedArea={
                Type : "restricted" ,
                id: "Rest " + String(restCounter),
                segmentName: "",
                state: "",
                algorithmType: "",
                base: currentMemoryLocation,
                size: listOfHoles[holeCounter].base - currentMemoryLocation
            }
            restCounter++;
            // Pushing new restritcted area to the global memory-list
            memList.push(TempRestrictedArea)
        }
        // Pushing new hole to the global memory-list
        memList.push(listOfHoles[holeCounter]);

        // Incrementing the memory-location to the end of the current pushed hole
        currentMemoryLocation = listOfHoles[holeCounter].base + listOfHoles[holeCounter].size;
        holeCounter++;
    }
    // Checking if all holes doesn't fill the whole memory & if that occurs
    // we push a new restricted area to fill the whole space left of memory
    if(currentMemoryLocation < memorySize){
        TempRestrictedArea={
            Type : "restricted" ,
            id: "Rest " + String(restCounter),
            processName: "",
            state: "",
            algorithmType: "",
            base: currentMemoryLocation,
            size: memorySize - currentMemoryLocation
        }
        memList.push(TempRestrictedArea);
    }

    var it=0;
    while(it<memList.length)
    {
           console.log(memList[it].id + "  " + memList[it].base+ "   " + memList[it].size);
        it++;
    }
    return memList
}

/**************************** allocateProcess Function ******************************/
function allocateProcess(listOfSegments)
{
    var it=0 ;
    for(it=0 ; it<memList.length ; it++)
    {
         console.log("Before --> ID: "+memList[it].id+"        "+"size: "+memList[it].size);
    }

    if(listOfSegments[0].algorithmType==="firstfit")
    {
       firstFitAlgorithm(listOfSegments);
        arrangeLists () ;
    }
    else
    {
       bestFitAlgorithm(listOfSegments);
       arrangeLists ();
        var i=0 ;
        for(i=0 ; i<listOfHoles.length ; i++)
        {
             console.log("list of Holes --> ID: "+listOfHoles[i].id+"        "+"size: "+listOfHoles[i].size);
        }
    }

    var itr=0 ;
    for(itr=0 ; itr<memList.length ; itr++)
    {
         console.log("After --> ID: "+memList[itr].id+memList[itr].segmentName + "        "+"size: "+memList[itr].size+ "        "+"base: "+memList[itr].base);
    }


}

/**************************** checkValidity Function ******************************/
function checkValidity(listOfSegments_temp)
{
    listOfSegments = listOfSegments_temp
    var sizeOfTotalHoles = getListSize(listOfHoles);
    var sizeOfTotalSegments = getListSize(listOfSegments);
    var isValid ;

    console.log("sizeOfTotalHoles: "+sizeOfTotalHoles+ "   " +"sizeOfTotalSegments "+sizeOfTotalSegments );
    //Case of total size of process is greater than total size of Holes then allocate in pendingList if it's a new process
    if(sizeOfTotalSegments > sizeOfTotalHoles)
    {
        //Error Signal will be emitted
        if(listOfSegments[0].state !=="pending")
        {
            // allocating segments at Pending List
            let tempList = JSON.parse(JSON.stringify(listOfSegments));

            pendingList.push(tempList);

            listOfSegments.splice(0,listOfSegments.length);

            console.log ("temp list length: "+tempList.length);

            var i=0 ;
            for(i=0 ; i<pendingList[0].length ; i++)
            {
                pendingList[pendingList.length-1][i].state="pending";
                console.log("After --> ID: "+pendingList[0][i].id+pendingList[0][i].segmentName + "        "+"size: "+pendingList[0][i].size+ "        "+"state: "+pendingList[0][i].state);
            }

        }
    }
    else
    {
        if(listOfSegments[0].algorithmType==="firstfit")
        {
           isValid = checkFirstFit(listOfSegments);
        }
        else
        {
            isValid = checkBestFit(listOfSegments);
        }
        console.log("isValid Vlaue: "+isValid);

        // Case of Allocation is Valid
        if(isValid===1)
        {
            // if the Process came from pendingList then pop it
            if(listOfSegments[0].state==="pending")
            {
                pendingList.splice(0,1);
            }

            // Make Allocation
            allocateProcess(listOfSegments);

        }
        // Case of Allocation is Invalid
        else if(isValid===0)
        {
            if(listOfSegments[0].state !=="pending")
            {
                // allocating segments at Pending List
                let tempList = JSON.parse(JSON.stringify(listOfSegments));

                pendingList.push(tempList);

                listOfSegments.splice(0,listOfSegments.length);

                console.log ("temp list length: "+tempList.length);

                var itr=0 ;
                for(itr=0 ; itr<pendingList[0].length ; itr++)
                {
                    pendingList[pendingList.length-1][itr].state="pending";
                    //console.log("After --> ID: "+pendingList[0][itr].id+pendingList[0][itr].segmentName + "        "+"size: "+pendingList[0][itr].size+ "        "+"state: "+pendingList[0][itr].state);
                }
            }

        }

    }
    return memList
}

/**************************** checkFirstFit Function ******************************/
function checkFirstFit(listOfSegments)
{
    let tempHoleList = JSON.parse(JSON.stringify(listOfHoles));
    var segItr=0 , holeItr=0;

    while(segItr<listOfSegments.length)
    {
        if(holeItr>=tempHoleList.length)
        {
            // Error is Happened
            // should be allocated in pending list
            return 0;
        }
        if(listOfSegments[segItr].size <= tempHoleList[holeItr].size)
        {
            //updates hole list by allocating segment size into The Hole
            tempHoleList[holeItr].size -= listOfSegments[segItr].size;
            segItr++;
            holeItr=0;
        }
        else
        {
            // increment holeItr
            holeItr++ ;
        }
    }
    return 1;
}


/**************************** checkBestFit Function ******************************/
function checkBestFit(listOfSegments)
{


    let tempHoleList = JSON.parse(JSON.stringify(listOfHoles));
    var segItr=0 , holeItr=0;

    // Sorting holes based on memSize
    tempHoleList.sort(function(a,b){
        return a.size - b.size;
    });
    while(segItr<listOfSegments.length)
    {
        if(holeItr>=tempHoleList.length)
        {
            // Error is Happened
            // should be allocated in pending list
            return 0;
        }
        if(listOfSegments[segItr].size <= tempHoleList[holeItr].size)
        {
            //updates hole list by allocating segment size into The Hole
            tempHoleList[holeItr].size -= listOfSegments[segItr].size;
            segItr++;
            holeItr=0;
        }
        else
        {
            // increment holeItr
            holeItr++ ;
        }
    }
    return 1;
}


/**************************** getListSize Function ******************************/
function getListSize(abstractList)
{
    var it=0 ;
    var totalsize=0;
    while(it< abstractList.length)
    {
        totalsize+=abstractList[it].size;
        it++;
    }
    return totalsize;
}


/**************************** bestFitAlgorithm Function ******************************/
function bestFitAlgorithm(listOfSegments)
{
    var segItr=0 , holeItr=0;


    // Sorting holes based on size
    listOfHoles.sort(function(a,b){
        return a.size - b.size;
    });

    while(segItr<listOfSegments.length)
    {

        if(holeItr>=listOfHoles.length)
        {
            // Error is Happened
            // should be allocated in pending list
            return 0;
        }
        if(listOfSegments[segItr].size <= listOfHoles[holeItr].size)
        {
            // Make Allocation in Memory List by sending
            // SegmentStruct to be updated
            // ID of The Hole to be Replaced by The segment
            updateMemoryList(listOfSegments[segItr],listOfHoles[holeItr].id);

            segItr++;
            holeItr=0;
        }
        else
        {
            // increment holeItr
            holeItr++ ;
        }
    }

}

/**************************** firstFitAlgorithm Function ******************************/
function firstFitAlgorithm(listOfSegments)
{
    var segItr=0 , holeItr=0;

    while(segItr<listOfSegments.length)
    {

        if(holeItr>=listOfHoles.length)
        {
            // Error is Happened
            // should be allocated in pending list
            return 0;
        }
        if(listOfSegments[segItr].size <= listOfHoles[holeItr].size)
        {
            // Make Allocation in Memory List by sending
            // SegmentStruct to be updated
            // ID of The Hole to be Replaced by The segment
            updateMemoryList(listOfSegments[segItr],listOfHoles[holeItr].id);

            segItr++;
            holeItr=0;
        }
        else
        {
            // increment holeItr
            holeItr++ ;
        }
    }


}

/**************************** updateMemoryList Function ******************************/
function updateMemoryList(segmentStruct,HoleID)
{
    if(segmentStruct.algorithmType==="firstfit")
    {
        // Sorting holes based on base address
        listOfHoles.sort(function(a,b){return a.base - b.base;});
    }
    var tempStruct ;
    var it=0 ;
    var newHoleSize=0;
    while(it< memList.length)
    {
        if(memList[it].id === HoleID)
        {

            //Updating The Hole with New size
            //console.log(memList[it].id +" Hole size after 2nd decrementation " + memList[it].size );

            memList[it].size = Math.abs(memList[it].size- segmentStruct.size) ;

            // Replace The Hole By segmentStruct incase that Hole size is equal to zero

            // update Segment base address
            segmentStruct.base = memList[it].base ;

            // update Hole base address
            memList[it].base += segmentStruct.size ;

            if(memList[it].size === 0)
            {
                memList.splice(it,1,segmentStruct);
                break ;
            }

            // Replacing The Hole By segmentStruct
            memList.splice(it,0,segmentStruct);
            break ;
        }
        it++;
    }
    for(var i = 0; i < listOfHoles.length ; i++)
    {
        console.log(listOfHoles[i].id,listOfHoles[i].base)
    }
}



/**************************** arrangeLists Function ******************************/
function arrangeLists ()
{
    listOfHoles.splice(0,listOfHoles.length);
    listOfSegments.splice(0,listOfSegments.length);

    var itr=0 ;
    while(itr<memList.length)
    {
        if(memList[itr].Type === "hole")
        {
            listOfHoles.push(memList[itr]);
        }
        itr++ ;
    }
}


/******************************************************* DEALLOCATING*********************************************/

function deallocate(name) {
    console.log(name)
    for(  var i = 0 ; i < memList.length ; i++)
    {
        if(memList[i].id === name)
        {
            memList[i].Type = "hole";
            //memList[i].id = "hole".concat(num.toString()); // concat("hole,listOfHoles.length)
            memList[i].id="hole"
            memList[i].processName= "";
            memList[i].state= "";
            memList[i].algorithmType= "";
           // listOfHoles.push(memList[i]);
         }
    }

    merge();
    arrangeLists ()

    if(pendingList.length>0)
    {
        let tempList = JSON.parse(JSON.stringify(pendingList[0]));

        listOfSegments=tempList;
        checkValidity(listOfSegments)
    }
    print()
    return memList
};

function merge()
{
    var numHole = 1
    var numRest = 1

    for( var i =  memList.length-1 ; i > 0; i--)
    {
        if(memList[i].Type==="hole" && memList[i-1].Type==="hole")
        {
            memList[i-1].size += memList[i].size
            memList.splice(i,1)
        }
    }

    //this function's role is to correct id-s after deallocation)
    for(  i = 0 ; i <  memList.length; i++){
        if(memList[i].Type==="hole" ){
            memList[i].id = "Hole ".concat((numHole++).toString())}
        if(memList[i].Type==="restricted" ){
            memList[i].id = "Rest ".concat((numRest++).toString())}
    }

}

function print() {

    for(  var i = 0 ; i < memList.length ; i++)
    {console.log("id: "+memList[i].id+" base: "+memList[i].base+" size: "+memList[i].size)}
    console.log("____________")
}

function mergeListOfHoles ()
{
    var it=0 ;
    var numHole=1;
    for(it= 0; it<listOfHoles.length-1 ; it++)
    {
        if(listOfHoles[it].base+listOfHoles[it].size === listOfHoles[it+1].base)
        {
            listOfHoles[it].size+=  listOfHoles[it+1].size;
            listOfHoles.splice(it+1,1);
        }
    }

    //this function's role is to correct id-s after deallocation)
    for(var  i = 0 ; i <  listOfHoles.length; i++)
    {
        if(listOfHoles[i].Type==="hole" ){
            listOfHoles[i].id = "Hole ".concat((numHole++).toString())}
    }
}
