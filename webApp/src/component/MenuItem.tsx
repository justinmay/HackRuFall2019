import React from 'react'; 
import '../stylesheets/MenuItem.css';

type MenuItemState = {
    image: string,
}

type MenuItemProps = {
    name: string,
    image: string,
    status: string,
    quantity: number,
    updateQuantity(name: string, modify: number): void,
}

class MenuItem extends React.Component<MenuItemProps,MenuItemState>{
    constructor(props:MenuItemProps){
        super(props)
        this.state = {
            image: this.props.name==="Dosa" ? "https://static01.nyt.com/images/2015/01/28/dining/28KITCHEN1/28KITCHEN1-articleLarge.jpg" :
            this.props.name==="Chicken Tikka Masala" ? 'https://s23209.pcdn.co/wp-content/uploads/2019/02/Easy-Chicken-Tikka-MasalaIMG_8253.jpg' :
            this.props.name==="PB&J" ? "https://vignette.wikia.nocookie.net/theoffice/images/e/e1/PamS6.jpg/revision/latest?cb=20100115200440" :
            ""
        }
    }
    render() {
        return(
            <div className="MenuItem">
                <div className="MenuLeft">
                    <img src={this.state.image} alt="Italian Trulli" style={{objectFit:"cover", height:"100%", width:"10vw",borderTopLeftRadius:"5px", borderBottomLeftRadius:"5px"}}/>
                        <h2 style={{marginLeft:"10px", fontSize:"4vw"}}>
                            {this.props.name} 
                        </h2>
                        <h2 style={{marginLeft:"10px", fontSize:"4vw", fontWeight:100}}>
                        - {this.props.status}
                        </h2>
                    </div>
                <div className="MenuRight">
                    <button className="increment" onClick={() => this.props.updateQuantity(this.props.name,-1)}>
                        -
                    </button>
                    <h2 style={{fontSize:"4vw"}}>
                        {this.props.quantity}
                    </h2>
                    <button className="increment" onClick={() => this.props.updateQuantity(this.props.name,1)}>
                        +
                    </button>
                </div>
            </div>
        )
    }
}

export default MenuItem;
