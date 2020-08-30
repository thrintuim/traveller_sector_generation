window.onload = function() {
    console.log('document loaded')
    var head = document.querySelector("head");
    var tradeStyle = document.createElement("style");
    tradeStyle.setAttribute("id", "trade");
    head.appendChild(tradeStyle);
    var currentSource = document.getElementById("source").selectedOptions[0].value;
    var currentTarget = document.getElementById("target").selectedOptions[0].value;
    setStyling(currentSource, currentTarget, "source", "target");
    selections = document.querySelectorAll('select');
    selections.forEach(
        function(currentValue, currentIndex, listObj) {
            currentValue.onchange = changeEventHandler;
        }
    );
}

function changeEventHandler(event) {
    // You can use “this” to refer to the selected element.
    var idvalue = this.id;
    if (idvalue === 'target') {
        var notidvalue = 'source'
    } else {
        var notidvalue = 'target'
    }
    console.log("changed: " + idvalue);
    console.log("didn't change: " + notidvalue);
    var selected = this.selectedOptions[0].value;
    console.log("selected value is: " + selected)
    var otherselected = document.getElementById(notidvalue).selectedOptions[0].value
    console.log("other selected value is: " + otherselected)
    setStyling(selected, otherselected, idvalue, notidvalue)
}
function setStyling(changed, notchanged, id, notid) {
    var changedStyle = "[data-'id'='value'].trade1 {stroke-width: 1; stroke: #000;}" +
        "[data-'id'='value'].trade2 {stroke-width: 2; stroke: #000;}";
    console.log(changed);
    var tradeStyle = document.getElementById('trade');
    console.log(tradeStyle.innerHTML)
    console.log(notchanged);
    if (changed === 'None' && notchanged === 'None') {
        console.log("in the none or none")
        tradeStyle.innerHTML = "";
    } else if (changed === 'All' && notchanged === 'All') {
        console.log("in the all and all");
        tradeStyle.innerHTML = ".trade1 { stroke-width: 1; stroke: #000; } .trade2 { stroke-width: 2; stroke: #000; }";
    } else if ((changed === 'None' || changed === 'All') && notchanged !== 'All') {
        var newstyle2 = changedStyle.replace(/data-'id'='value'/g, "data-" + notid + "='" + notchanged + "'");
        style = newstyle2;
        tradeStyle.innerHTML = style;
    } else if (changed !== 'All' && (notchanged === 'None' || notchanged === 'All')) {
        var newstyle1  = changedStyle.replace(/data-'id'='value'/g, "data-" + id + "='" + changed + "'");
        style = newstyle1;
        tradeStyle.innerHTML = style;
    } else if (changed !== 'All' && notchanged !== 'All') {
        var newstyle1  = changedStyle.replace(/data-'id'='value'/g, "data-" + id + "='" + changed + "'");
        var newstyle2 = changedStyle.replace(/data-'id'='value'/g, "data-" + notid + "='" + notchanged + "'");
        style = newstyle1 + newstyle2;
        tradeStyle.innerHTML = style;
    }
}