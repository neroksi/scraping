// Add active class to the current button (highlight it)
// function active() {


function active() {
    var current = document.querySelector("#scraping-navbar ul>li.active");
    if( !current){ 
        // current = document.querySelector("nav>ul>li:hover");
        this.className +=  " active";
        console.log(this.textContent + "111111");
    }
        
    else{
        current.className = current.className.replace(" active", "");
        if(this.textContent != current.textContent) {this.className +=  " active";}
        console.log(this.textContent + "2222222");
    }

    

    }

var header = document.querySelector("#scraping-navbar ul");
var lis = header.querySelectorAll("li");
for (var i = 0; i < lis.length; i++) {
  lis[i].addEventListener("click", active);
    
}
// }