
var memList = [];
var listOfHoles = [];
var memorySize = 100

var struct = {
    Type : "hole", // hole,restricted,segment
    id : "hole1", //hole+i,rest+i,p+i
    segmentName : "", //any valid name
    state: "", //new, pending
    algorithmType: "",//firstfit,bestfit
    base:10,//int
    size:10//int
};

listOfHoles.push(struct);

struct = {
    Type : "hole",
    id: "hole2",
    segmentName: "",
    state: "",
    algorithmType: "",
    base:25,
    size:5
};

listOfHoles.push(struct);

struct = {
    Type : "hole",
    id: "hole3",
    segmentName: "",
    state: "",
    algorithmType: "",
    base:0,
    size:5
};

listOfHoles.push(struct);

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
                processName: "",
                state: "",
                algorithmType: "",
                base: currentMemoryLocation,
                size: currentMemoryLocation+listOfHoles[holeCounter].base
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

}


function allocateProcess(){



}


function checkValidity(){


}

function bestFitAlgorithm(){

}


function firstFitAlgorithm(){


}

