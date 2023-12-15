import { css } from "uebersicht"

export const command = "id -F"

export const refreshFrequency = false

const profileContaienr = css`
display: flex;
align-items: center;
justify-content: center;
width: 100vw;
height: 95vh;
`

const profileInner = css``

const profilePic = css`
  width: 120px;
  height: 120px;
  border-radius: 50%;
  border: 0px solid #fff;
  margin: auto;
  display: block;
  box-shadow: 0 3px 6px rgba(0,0,0,0.08), 0 3px 6px rgba(0,0,0,0.12);
`

const profileName = css`
  font-family: "Avenir Next";
  font-weight: 400;
  text-align: center;
  color: #fff;
  text-shadow: 0 3px 6px rgba(0,0,0,0.08), 0 3px 6px rgba(0,0,0,0.12);
`

export const render = ({ output }) => (
    <div className={profileContaienr}>
        <div className={profileInner}>
            <img className={profilePic} src="/profile.widget/profile.jpg" alt=""/>
            {/* <h1 className={profileName}>{output}</h1> */}
            <h2 className={profileName}>{"simsim"}</h2>
        </div>
    </div>
)
