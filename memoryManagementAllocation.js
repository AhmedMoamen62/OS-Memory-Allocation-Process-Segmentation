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
    base:30,
    size:16
};
listOfSegments.push(struct);

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg2",
    state: "new",
    algorithmType: "firstfit",
    base:40,
    size:30
};
listOfSegments.push(struct);

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg3",
    state: "new",
    algorithmType: "firstfit",
    base:70,
    size:9
};
listOfSegments.push(struct);

struct = {
    Type : "segment",
    id: "p1",
    segmentName: "seg4",
    state: "new",
    algorithmType: "firstfit",
    base:70,
    size:10
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

    if(listOfSegments[0].algorithmType==="f_fit")
    {
       firstFitAlgorithm(listOfSegments);
    }
    else
    {
       bestFitAlgorithm(listOfSegments);
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
    if(listOfSegments[0].algorithmType==="f_fit")
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
            console.log("hole_it: "+ holeItr+"     "+ "segment_it: "+ segItr);
            console.log("size before " + tempHoleList[holeItr].size) ;

            //updates hole list by allocating segment size into The Hole
            tempHoleList[holeItr].size -= listOfSegments[segItr].size;

            console.log("size after " + tempHoleList[holeItr].size) ;
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

            // updates hole list by allocating segment size into The Hole
            listOfHoles[holeItr].size -= listOfSegments[segItr].size;

            // Make Allocation in Memory List by sending
            // SegmentStruct to be updated
            // ID of The Hole to be Replaced by The segment
            updateMemoryList(listOfSegments[segItr],listOfHoles[holeItr].id);

            // Remove Hole from ListOfHoles if its size = zero
            if(listOfHoles[holeItr].size===0)
            {
                listOfHoles.splice(holeItr,1);
            }

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


}

function updateMemoryList(segmentStruct,HoleID)
{
    var tempStruct ;
    var it=0 ;
    var newHoleSize=0;
    while(it< memList.length)
    {
        if(memList[it].id===HoleID)
        {

            //Updating The Hole with New size
            memList[it].size = Math.abs(memList[it].size- segmentStruct.size) ;

            // Replace The Hole By segmentStruct incase that Hole size is equal to zero
            if(memList[it].size === 0)
            {
                console.log("Test1 --> ID: "+memList[it].id + memList[it].segmentName +"        "+"size: "+memList[it].size);
                memList.splice(it,1,segmentStruct);
                 console.log("Test2 --> ID: "+memList[it].id+ memList[it].segmentName +"        "+"size: "+memList[it].size);
                break ;
            }

            // update Segment base address
            segmentStruct.base = memList[it].base ;

            // update Hole base address
            memList[it].base += segmentStruct.size ;



            // Replacing The Hole By segmentStruct
            memList.splice(it,0,segmentStruct);
            break ;
        }
        it++;
    }
}




