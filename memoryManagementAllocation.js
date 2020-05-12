var memList = [];
let listOfHoles = [];
var memorySize = 100
var listOfSegments= [];
let tempHoleList = [] ;
/******************************************************************/


/************************************************************************************/

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg1",
    state: "new",
    algorithmType: "firstfit",
    base:-1,
    size:9
};
listOfSegments.push(struct);

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg2",
    state: "new",
    algorithmType: "firstfit",
    base:-1,
    size:16
};
listOfSegments.push(struct);

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg3",
    state: "new",
    algorithmType: "firstfit",
    base:-1,
    size:20
};
listOfSegments.push(struct);

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg4",
    state: "new",
    algorithmType: "firstfit",
    base:70,
    size:30
};
listOfSegments.push(struct);


/********************************************/


var struct = {
    Type : "hole", // hole,restricted,segment
    id : "hole1", //hole+i,rest+i,p+i
    segmentName : "", //any valid name
    state: "", //new, pending
    algorithmType: "",//firstfit,bestfit
    base:10,//int
    size:18//int
};

listOfHoles.push(struct);
tempHoleList.push(struct);

struct = {
    Type : "hole",
    id: "hole2",
    segmentName: "",
    state: "",
    algorithmType: "",
    base:30,
    size:9
};

listOfHoles.push(struct);
tempHoleList.push(struct);

struct = {
    Type : "hole",
    id: "hole3",
    segmentName: "",
    state: "",
    algorithmType: "",
    base:50,
    size:30
};

listOfHoles.push(struct);
tempHoleList.push(struct);

var struct = {
    Type : "hole", // hole,restricted,segment
    id : "hole4", //hole+i,rest+i,p+i
    segmentName : "", //any valid name
    state: "", //new, pending
    algorithmType: "",//firstfit,bestfit
    base:80,//int
    size:20//int
};

listOfHoles.push(struct);
//tempHoleList.push(struct);

/* Implmementation of memory initialization-list by pushing to the global list
 * specific number of holes & restricted areas to fill the memory
*/
function initializeMemory(){


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
                id: "rest" + String(restCounter),
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
            id: "rest" + String(restCounter),
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


}


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


function checkValidity()
{
    var sizeOfTotalHoles = getListSize(listOfHoles);
    var sizeOfTotalSegments = getListSize(listOfSegments);
    var isValid ;

    if(sizeOfTotalSegments > sizeOfTotalHoles)
    {
        //Error Signal will be emitted
    }
    if(listOfSegments[0].algorithmType==="firstfit")
    {
       isValid = checkFirstFit(listOfSegments);
    }
    else
    {
        isValid = checkBestFit(listOfSegments);
    }
    console.log("isValid Vlaue: "+isValid);

    if(isValid===1)
    {
        // Make Allocation
        allocateProcess(listOfSegments);
    }
    else
    {
        // emit error Signal
    }

}

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

function updateMemoryList(segmentStruct,HoleID)
{
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
}



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
